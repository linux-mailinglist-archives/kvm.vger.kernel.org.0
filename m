Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4A019A208
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 00:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbgCaWm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 18:42:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34012 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgCaWm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 18:42:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id 65so28275790wrl.1;
        Tue, 31 Mar 2020 15:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1jsuwtxuUphpE0RZhef4PDISQgTlLi4Ca2smnB8QhUI=;
        b=qFpsBADrpxeqLat60SC4r8eFLqa9EQpyfUJ0PHJjOUDv77WE2TTxgmJJIvqryxuVqE
         VIRRwBBYy8UymCCCsmMqHyLxeegl8aHL1M186n9xpumZduxYHgPAkyLPCGgRW7tupUbx
         nUobJ22z7KXcOaqDf52le4WcqjXXJ7CK24z6WBMVsc/jZ8h8J/h3R2UKchatYLniqYKw
         Yg6DWBaPlwL+w7vTkHkz9QbOtYo0W05KsdcCIvSOrPMhvHWiTmKtYyVfTJYpYRT4x8UZ
         AVbqszIl251A+i2FjHwie8m0X8hECIZ6M7c/RUXHWIXefEkCY2YqMi6SrtjDqOEUKrUf
         aXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=1jsuwtxuUphpE0RZhef4PDISQgTlLi4Ca2smnB8QhUI=;
        b=VeADCdpQvFHtHfq1HTJ+hD7Gl1J0K7T6anCuIvcFyqFZC8y+Z507lQEOtU3kRHczn6
         qAvZ8Qn215S+SazVZr+ei/Wl4kj5JzvTny6jqLrrWpoE4uq+GBOfl7mv8/1H+SzmDtoo
         0/gZRwWc4Dwc2FRhuJGl75bIYPG60Rtg7vKsmOerBukseVcgXu7nBGO9WVehoLDjQEsS
         Ha+scq4wUt53jmI/4m3Yo/9S/r65QUcW2RYSEX2sTo/+D9DCXG6uDbrOjAp3LLQMJXc+
         QztYY6oLAbB1yzVbnMZiAM+gGXWASIGdI+wC4t+DNxgF0HGyR8zHJoTI+iO7m5ttbYG0
         060w==
X-Gm-Message-State: ANhLgQ1pD4lpwh9jnQGjWby7rLA7oexhcF/LGnQbVMt4FYDSO02ruMAz
        kZ87RUJlzzrJlgILtBcSr1LzCLm0BtI=
X-Google-Smtp-Source: ADFU+vvRoF9pFdVcJa9cMPcXPxkqycsPt/wZshyxiR0NL1tLIR0+e5n+OF7X4t22pk3doCclhV3r9g==
X-Received: by 2002:adf:9dca:: with SMTP id q10mr22166975wre.11.1585694545103;
        Tue, 31 Mar 2020 15:42:25 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id q13sm275388wrg.21.2020.03.31.15.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 15:42:24 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     eesposit@redhat.com
Subject: [PATCH] KVM: x86: move kvm_create_vcpu_debugfs after last failure point
Date:   Wed,  1 Apr 2020 00:42:22 +0200
Message-Id: <20200331224222.393439-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The placement of kvm_create_vcpu_debugfs is more or less irrelevant, since
it cannot fail and userspace should not care about the debugfs entries until
it knows the vcpu has been created.  Moving it after the last failure
point removes the need to remove the directory when unwinding the creation.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 027259af883e..0a78e1d874ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2823,8 +2823,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_free_run_page;
 
-	kvm_create_vcpu_debugfs(vcpu);
-
 	mutex_lock(&kvm->lock);
 	if (kvm_get_vcpu_by_id(kvm, id)) {
 		r = -EEXIST;
@@ -2853,11 +2851,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_postcreate(vcpu);
+	kvm_create_vcpu_debugfs(vcpu);
 	return r;
 
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
-	debugfs_remove_recursive(vcpu->debugfs_dentry);
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
-- 
2.24.1

