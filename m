Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54410529385
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349638AbiEPWTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347825AbiEPWTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:19:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B75844741
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:19:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n10so15755403pjh.5
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bGJGZqlMLWsgZLmLkpOZQTitKuhIIikTc7afzPIoFNM=;
        b=ClZPTs0qNNgPM++8Opal5DzOkn2IGGkp8Ksxo6fc7IOsb8UThtSqdjfbM1BbAwQyQP
         5cvFOPMzaOgJkb0BtSk6YhYsjeSU9AqmRB1o8JY5Vsg5w31uQP4RJGubKyoeX9INosLf
         5ozyISi8HRTam917LtIUXxWrTBnKhNYNrZGFR4fSuQnkaoD3MJpmSGdvn90ZBHea0H6M
         4/1E7+z5NVd4p+nTd96XQ1mFPZPlFnbc5idbLdzFT2FC53hHzDFb0HwNCdxp9HE1Z3cC
         y6drIlJj1krktmHg8WXvHcU/e1PpLYFv4PXWIS2800Bwy1RbKF6dXsVoGJ77aDPDb/rV
         KohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bGJGZqlMLWsgZLmLkpOZQTitKuhIIikTc7afzPIoFNM=;
        b=pbkBSAS8UCPHsFUAJEJNDL94Hepwn448mtoAUVG+XQKbPdGAmhrYGU2uNpahoL5NnB
         4mVo88go3OHNlzHlKKUUfG7okCDo56MgMUhe6BEIL7gf0SyngUl5d1NXxGvZrDXYFTOX
         yRmpO06YhKjtLxcXbtBJIZa61gXuBGQgarjpVUThQ/oqJvWAORoL8R8o2twNVfigNt4e
         +bQrZ7EOvdbcttrZTmRNh6r2bVivFO7FfsVNutTT4LCnO9Qc9hyvtDt0fi4jfHKzNtgL
         kvDJdzBVyOU7wsDqIzMZ8uHfuh9b2fFcaGAD9OF7YTUW6drYlSRrn0UGMMFtiXuOg+kN
         vayA==
X-Gm-Message-State: AOAM531ol7bjW+aPfV4g634dloFl73Xloi7rZc4tIjco6500TPmMzPZh
        6kX7N2no8XhuyDumtiB8Yjp/sk/vofIjoQ==
X-Google-Smtp-Source: ABdhPJwb2HEIZfznhH3rseGV+mKXznmoD72gc3IKrN+cL0Mo519vdrE7pQhVWDjt6nNb3HcoPS/vjw==
X-Received: by 2002:a17:902:f0cb:b0:161:7747:63b0 with SMTP id v11-20020a170902f0cb00b00161774763b0mr7646307pla.116.1652739572720;
        Mon, 16 May 2022 15:19:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090ad10300b001d26f134e43sm165614pju.51.2022.05.16.15.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 15:19:31 -0700 (PDT)
Date:   Mon, 16 May 2022 22:19:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: Actually create debugfs in kvm_create_vm()
Message-ID: <YoLN8M9I0bAnO3Nu@google.com>
References: <20220415201542.1496582-1-oupton@google.com>
 <20220415201542.1496582-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415201542.1496582-5-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022, Oliver Upton wrote:
> @@ -1049,7 +1050,7 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
>  	return 0;
>  }
>  
> -static struct kvm *kvm_create_vm(unsigned long type)
> +static struct kvm *kvm_create_vm(unsigned long type, int fd)

I don't love passing in @fd, because actually doing anything but printing the
@fd in a string is doomed to fail.

Rather than pass the raw fd, what about passing in just its name?

---
 virt/kvm/kvm_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d94c1d9ecaa9..ac76fc7f2e4d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -964,7 +964,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	}
 }

-static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
+static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 {
 	static DEFINE_MUTEX(kvm_debugfs_lock);
 	struct dentry *dent;
@@ -987,7 +987,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	if (!debugfs_initialized())
 		return 0;

-	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
+	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
 	mutex_lock(&kvm_debugfs_lock);
 	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
 	if (dent) {
@@ -1076,7 +1076,7 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 	return 0;
 }

-static struct kvm *kvm_create_vm(unsigned long type, int fd)
+static struct kvm *kvm_create_vm(unsigned long type, const char * fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
 	struct kvm_memslots *slots;
@@ -1174,7 +1174,7 @@ static struct kvm *kvm_create_vm(unsigned long type, int fd)
 		goto out_err_mmu_notifier;
 	}

-	r = kvm_create_vm_debugfs(kvm, fd);
+	r = kvm_create_vm_debugfs(kvm, fdname);
 	if (r)
 		goto out_err;

@@ -4781,6 +4781,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);

 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
+	char fdname[ITOA_MAX_LEN + 1];
 	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
@@ -4789,7 +4790,9 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (fd < 0)
 		return fd;

-	kvm = kvm_create_vm(type, fd);
+	snprintf(fdname, sizeof(fdname), "%d", fd);
+
+	kvm = kvm_create_vm(type, fdname);
 	if (IS_ERR(kvm)) {
 		r = PTR_ERR(kvm);
 		goto put_fd;

base-commit: 3d7c3ff77a78f103c2cf1104157a4132f56fd6d1
--

