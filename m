Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E54429EA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437021AbfFLOuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 10:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436952AbfFLOuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 10:50:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F488206BB;
        Wed, 12 Jun 2019 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560351036;
        bh=rTbyq5MmyIh2UQAp0E6ynXYPmdgyNJkcG0/LtgC2t/o=;
        h=Date:From:To:Cc:Subject:From;
        b=CAMND5IBjqjHNvOr7moy6UJyUD4K+mD5A2K/3+FFoimbibtGPsGG0wLiGk8fhL0u2
         vZXpmzd9HNkDn889jfbMfxE9aKcS2nEnLXyqIRWOgcwg4PJGwURMesR294I/zL3AWC
         QqPeCcd5XUYRPIGTS81ItblG7zH7EOjO7oiLrXy4=
Date:   Wed, 12 Jun 2019 16:50:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH] kvm: remove invalid check for debugfs_create_dir()
Message-ID: <20190612145033.GA18084@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

debugfs_create_dir() can never return NULL, so no need to check for an
impossible thing.

It's also not needed to ever check the return value of this function, so
just remove the check entirely, and indent the previous line to a sane
formatting :)

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ca54b09adf5b..4b4ef642d8fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2605,9 +2605,7 @@ static int kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 
 	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
 	vcpu->debugfs_dentry = debugfs_create_dir(dir_name,
-								vcpu->kvm->debugfs_dentry);
-	if (!vcpu->debugfs_dentry)
-		return -ENOMEM;
+						  vcpu->kvm->debugfs_dentry);
 
 	ret = kvm_arch_create_vcpu_debugfs(vcpu);
 	if (ret < 0) {
-- 
2.22.0

