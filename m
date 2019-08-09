Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64A87F6B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437139AbfHIQQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:30 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52904 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437012AbfHIQO7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:14:59 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5DF7B305D3D0;
        Fri,  9 Aug 2019 19:00:54 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0C0B7305B7A0;
        Fri,  9 Aug 2019 19:00:54 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 07/92] kvm: introspection: honor the reply option when handling the KVMI_GET_VERSION command
Date:   Fri,  9 Aug 2019 18:59:22 +0300
Message-Id: <20190809160047.8319-8-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Obviously, the KVMI_GET_VERSION command must not be used when the command
reply is disabled by a previous KVMI_CONTROL_CMD_RESPONSE command.

This commit changes the code path in order to check the reply option
(enabled/disabled) before trying to reply to this command. If the command
reply is disabled it will return an error to the caller. In the end, the
receiving worker will finish and the introspection socket will be closed.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/kvmi_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index ea5c7e23669a..2237a6ed25f6 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -169,7 +169,7 @@ static int handle_get_version(struct kvmi *ikvm,
 	memset(&rpl, 0, sizeof(rpl));
 	rpl.version = KVMI_VERSION;
 
-	return kvmi_msg_vm_reply(ikvm, msg, 0, &rpl, sizeof(rpl));
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, 0, &rpl, sizeof(rpl));
 }
 
 static bool is_command_allowed(struct kvmi *ikvm, int id)
