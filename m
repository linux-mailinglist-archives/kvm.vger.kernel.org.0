Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D0454E906
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358129AbiFPSDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346839AbiFPSDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:03:30 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8201FCC4
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:03:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so896908pjm.4
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dpwRjZkY0soBd7SZeyYmsUgUNEzUZCI9CCQptugljFw=;
        b=UksF026gnR/KU1E9qCj/FJRMQlvjtO+weLdjQnoyf2sA23bDJn2J9sOnjNEIYgiftN
         xZ69NSdeSMiOLiOrYgPMmD4h0FncrgNYSHPz/kuAD+1wz5wWvkyQYhGLS2nUjDt1Oa8V
         aCcQ2B0b9PebaGTO0F9y3Vfqd7W75tvTNVale7X9R1pdSe3aTsB/fdy+tkYNGoeqtJis
         zsqUzVFxbuTi/EyqqC5aSdi809j8M28blIr8FKh9o7aUQ3aG2+LW9NxoP5YJJsLarTHQ
         ngKCS75UZSdg2P6b3UZx5EB87eWm1RxEuZhF4dDF2ya01I7LtqaYhXuIxHvzEsVEkEzG
         qRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dpwRjZkY0soBd7SZeyYmsUgUNEzUZCI9CCQptugljFw=;
        b=thhnqOA0Y5lY+ggBDED6FG/lliVeIAqebJQNULGGp5pzfBW62GuZQzTcpm1/gtedUY
         2xCzZO8VR1OMkZGc+0vee5I+Eh4xhv/2xhR35X3e5Mh6Xw5KFnZDG3poMPIWQ0E3pSLe
         tJVtqTS8iqaX/LjW0ny1ozekelHRTaM8uu+Ig+acIA3AsmcWPuT/d76WMPHz3s62TG0q
         JEkJJ38S1prhLT/iYm3IkyvMUzdmVxtocIHTO/2bn+mW98ehi2SSoIdhgc3rIXsrIz7u
         Ejctr7OruwoTA0KqKD8q1RUrii83R1iKhb8LHLrv1GLQs2x4e9HWf1C8bSVwVfnVBH1e
         PPWA==
X-Gm-Message-State: AJIora/D1iqW5jkhWSI3mMv3gxKW3/hDljyp/BtnhLXUiKhMTg0ebFpc
        p/0k3X9bJppZrwwleUicoHD+lw==
X-Google-Smtp-Source: AGRyM1th7y9kU912egDEqaQRM2cWr2EeuEK0IxOfKI6Ig3eg9SH7wwuhIvdQ8nKB8hw7YWtZulQUZQ==
X-Received: by 2002:a17:902:7b8b:b0:168:a7d0:ddf3 with SMTP id w11-20020a1709027b8b00b00168a7d0ddf3mr6034931pll.118.1655402608624;
        Thu, 16 Jun 2022 11:03:28 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f62-20020a623841000000b0050dc762814asm2070595pfa.36.2022.06.16.11.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:03:27 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:03:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 4/5] KVM: Actually create debugfs in kvm_create_vm()
Message-ID: <Yqtwa03IWVNP4LLA@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-5-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022, Oliver Upton wrote:
> Doing debugfs creation after vm creation leaves things in a
> quasi-initialized state for a while. This is further complicated by the
> fact that we tear down debugfs from kvm_destroy_vm(). Align debugfs and
> stats init/destroy with the vm init/destroy pattern to avoid any
> headaches. Pass around the fd number as a string, as poking at the fd in
> any other way is nonsensical.

"any other way before it is installed", otherwise it sounds like the fd is this
magic black box that KVM can't touch.

And the changes to pass @fdname instead of @fd should be a separate patch, both to
reduce churn and because it's not a risk free change, e.g. if this is the improper
size then bisection should point at the fdname patch, not at this combined patch.

	char fdname[ITOA_MAX_LEN + 1];

> Note the fix for a benign mistake in error handling for calls to
> kvm_arch_create_vm_debugfs() rolled in. Since all implementations of
> the function return 0 unconditionally it isn't actually a bug at
> the moment.
> 
> Lastly, tear down debugfs/stats data in the kvm_create_vm_debugfs()
> error path. Previously it was safe to assume that kvm_destroy_vm() would
> take out the garbage, that is no longer the case.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

...

> @@ -4774,6 +4781,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
>  
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
> +	char fdname[ITOA_MAX_LEN + 1];
>  	int r, fd;
>  	struct kvm *kvm;
>  	struct file *file;
> @@ -4782,7 +4790,8 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  	if (fd < 0)
>  		return fd;
>  
> -	kvm = kvm_create_vm(type);
> +	snprintf(fdname, sizeof(fdname), "%d", fd);

Nit, I'd prefer a blank line here so that it's easier to see the call to
kvm_create_vm().

> +	kvm = kvm_create_vm(type, fdname);
>  	if (IS_ERR(kvm)) {
>  		r = PTR_ERR(kvm);
>  		goto put_fd;
> @@ -4799,17 +4808,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  		goto put_kvm;
>  	}
>  
> -	/*
> -	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
> -	 * already set, with ->release() being kvm_vm_release().  In error
> -	 * cases it will be called by the final fput(file) and will take
> -	 * care of doing kvm_put_kvm(kvm).
> -	 */

I think we should keep the comment to warn future developers.  I'm tempted to say
it could be reworded to say something like "if you're adding a call that can fail
at this point, you're doing it wrong".  But for this patch, I'd say just leave the
comment intact.

> -	if (kvm_create_vm_debugfs(kvm, r) < 0) {
> -		fput(file);
> -		r = -ENOMEM;
> -		goto put_fd;
> -	}
>  	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>  
>  	fd_install(fd, file);
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
