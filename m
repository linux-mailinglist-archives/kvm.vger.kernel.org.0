Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8051D689B
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 17:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgEQP2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 11:28:55 -0400
Received: from foss.arm.com ([217.140.110.172]:55194 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgEQP2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 11:28:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D00531B;
        Sun, 17 May 2020 08:28:54 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF0E93F52E;
        Sun, 17 May 2020 08:28:53 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: [PATCH kvmtool] net: uip: Fix GCC 10 warning about checksum calculation
Date:   Sun, 17 May 2020 16:28:49 +0100
Message-Id: <20200517152849.204717-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC 10.1 generates a warning in net/ip/csum.c about exceeding a buffer
limit in a memcpy operation:
------------------
In function ‘memcpy’,
    inlined from ‘uip_csum_udp’ at net/uip/csum.c:58:3:
/usr/include/aarch64-linux-gnu/bits/string_fortified.h:34:10: error: writing 1 byte into a region of size 0 [-Werror=stringop-overflow=]
   34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from net/uip/csum.c:1:
net/uip/csum.c: In function ‘uip_csum_udp’:
include/kvm/uip.h:132:6: note: at offset 0 to object ‘sport’ with size 2 declared here
  132 |  u16 sport;
------------------

This warning originates from the code taking the address of the "sport"
member, then using that with some pointer arithmetic in a memcpy call.
GCC now sees that the object is only a u16, so copying 12 bytes into it
cannot be any good.
It's somewhat debatable whether this is a legitimate warning, as there
is enough storage at that place, and we knowingly use the struct and
its variabled-sized member at the end.

However we can also rewrite the code, to not abuse the "&" operation of
some *member*, but take the address of the struct itself.
This makes the code less dodgy, and indeed appeases GCC 10.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 net/uip/csum.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/uip/csum.c b/net/uip/csum.c
index 7ca8bada..607c9f1c 100644
--- a/net/uip/csum.c
+++ b/net/uip/csum.c
@@ -37,7 +37,7 @@ u16 uip_csum_udp(struct uip_udp *udp)
 	struct uip_pseudo_hdr hdr;
 	struct uip_ip *ip;
 	int udp_len;
-	u8 *pad;
+	u8 *udp_hdr = (u8*)udp + offsetof(struct uip_udp, sport);
 
 	ip	  = &udp->ip;
 
@@ -50,13 +50,12 @@ u16 uip_csum_udp(struct uip_udp *udp)
 	udp_len	  = uip_udp_len(udp);
 
 	if (udp_len % 2) {
-		pad = (u8 *)&udp->sport + udp_len;
-		*pad = 0;
-		memcpy((u8 *)&udp->sport + udp_len + 1, &hdr, sizeof(hdr));
-		return uip_csum(0, (u8 *)&udp->sport, udp_len + 1 + sizeof(hdr));
+		udp_hdr[udp_len] = 0;		/* zero padding */
+		memcpy(udp_hdr + udp_len + 1, &hdr, sizeof(hdr));
+		return uip_csum(0, udp_hdr, udp_len + 1 + sizeof(hdr));
 	} else {
-		memcpy((u8 *)&udp->sport + udp_len, &hdr, sizeof(hdr));
-		return uip_csum(0, (u8 *)&udp->sport, udp_len + sizeof(hdr));
+		memcpy(udp_hdr + udp_len, &hdr, sizeof(hdr));
+		return uip_csum(0, udp_hdr, udp_len + sizeof(hdr));
 	}
 
 }
@@ -66,7 +65,7 @@ u16 uip_csum_tcp(struct uip_tcp *tcp)
 	struct uip_pseudo_hdr hdr;
 	struct uip_ip *ip;
 	u16 tcp_len;
-	u8 *pad;
+	u8 *tcp_hdr = (u8*)tcp + offsetof(struct uip_tcp, sport);
 
 	ip	  = &tcp->ip;
 	tcp_len   = ntohs(ip->len) - uip_ip_hdrlen(ip);
@@ -81,12 +80,11 @@ u16 uip_csum_tcp(struct uip_tcp *tcp)
 		pr_warning("tcp_len(%d) is too large", tcp_len);
 
 	if (tcp_len % 2) {
-		pad = (u8 *)&tcp->sport + tcp_len;
-		*pad = 0;
-		memcpy((u8 *)&tcp->sport + tcp_len + 1, &hdr, sizeof(hdr));
-		return uip_csum(0, (u8 *)&tcp->sport, tcp_len + 1 + sizeof(hdr));
+		tcp_hdr[tcp_len] = 0;		/* zero padding */
+		memcpy(tcp_hdr + tcp_len + 1, &hdr, sizeof(hdr));
+		return uip_csum(0, tcp_hdr, tcp_len + 1 + sizeof(hdr));
 	} else {
-		memcpy((u8 *)&tcp->sport + tcp_len, &hdr, sizeof(hdr));
-		return uip_csum(0, (u8 *)&tcp->sport, tcp_len + sizeof(hdr));
+		memcpy(tcp_hdr + tcp_len, &hdr, sizeof(hdr));
+		return uip_csum(0, tcp_hdr, tcp_len + sizeof(hdr));
 	}
 }
-- 
2.17.1

