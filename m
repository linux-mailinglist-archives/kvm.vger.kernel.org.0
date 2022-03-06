Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD80F4CE7F9
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 01:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiCFAuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 19:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFAuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 19:50:03 -0500
Received: from relay5.hostedemail.com (relay5.hostedemail.com [64.99.140.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5342B7A9B5
        for <kvm@vger.kernel.org>; Sat,  5 Mar 2022 16:49:12 -0800 (PST)
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A9E8474;
        Sun,  6 Mar 2022 00:49:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 2F83620011;
        Sun,  6 Mar 2022 00:49:10 +0000 (UTC)
Message-ID: <6185c67d2cca274aee019808f16855ecfd0c33d8.camel@perches.com>
Subject: Re: [PATCH 2/6] KVM: Replace bare 'unsigned' with 'unsigned int'
From:   Joe Perches <joe@perches.com>
To:     Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 05 Mar 2022 16:49:09 -0800
In-Reply-To: <20220305205528.463894-3-henryksloan@gmail.com>
References: <20220305205528.463894-1-henryksloan@gmail.com>
         <20220305205528.463894-3-henryksloan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Stat-Signature: qg7qgw7nknhygyx8buxkk1k9dxxgho6h
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 2F83620011
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/ss7Wion9R5Tx6ngsggSoSpNtuOFElpKU=
X-HE-Tag: 1646527750-232767
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-03-05 at 15:55 -0500, Henry Sloan wrote:
> Signed-off-by: Henry Sloan <henryksloan@gmail.com>
> ---
>  virt/kvm/coalesced_mmio.c |  2 +-
[]
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
[]
> @@ -43,7 +43,7 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
>  static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
>  {
>  	struct kvm_coalesced_mmio_ring *ring;
> -	unsigned avail;
> +	unsigned int avail;
>  
>  	/* Are we able to batch it ? */
>  

Instead of just converting this to unsigned int,
the function return could be converted to bool.

So could another int return in the same file.

Something like:
---
 virt/kvm/coalesced_mmio.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f2..452ae20c9ed06 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -22,28 +22,28 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_coalesced_mmio_dev, dev);
 }
 
-static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
-				   gpa_t addr, int len)
+static bool coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
+				    gpa_t addr, int len)
 {
 	/* is it in a batchable area ?
 	 * (addr,len) is fully included in
 	 * (zone->addr, zone->size)
 	 */
 	if (len < 0)
-		return 0;
+		return false;
 	if (addr + len < addr)
-		return 0;
+		return false;
 	if (addr < dev->zone.addr)
-		return 0;
+		return false;
 	if (addr + len > dev->zone.addr + dev->zone.size)
-		return 0;
-	return 1;
+		return false;
+
+	return true;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
+static bool coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
-	unsigned avail;
 
 	/* Are we able to batch it ? */
 
@@ -52,13 +52,8 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 	 * there is always one unused entry in the buffer
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
-	avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
-	if (avail == 0) {
-		/* full */
-		return 0;
-	}
 
-	return 1;
+	return (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX != 0;
 }
 
 static int coalesced_mmio_write(struct kvm_vcpu *vcpu,


