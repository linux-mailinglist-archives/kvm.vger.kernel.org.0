Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0333946C7B9
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 23:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242355AbhLGWv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 17:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242348AbhLGWvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 17:51:23 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB53DC061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 14:47:52 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id s139so1287000oie.13
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 14:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANaVoXu55ljkpav9SN1pj18NmEH8lx2ewAQtH2fHYB0=;
        b=ixgoSnmmBpMMYicNrHKI5rVjsYCEAUnD4nFbCAbeGei42pR3CWO2tz+WjHFHgydtzf
         lTGw+uNX8IVjY3noyK5odC+HsvDMOLccbRAXKKjA0j5YsvHqBHzixTnDv7Gocnv4BGwt
         FjjBUu5q7lGv2Uj7wZZnDpUebmevcp/jX7LuVBCQG2B7t7MmFccN1r8Q7+35nkd82Xfs
         PMLhP7JDJEj2iI1mi27ezQrmLUyK8fXSV3d5YXn7aidWcdWpZ0GA0KqWFxHY/xnk8Dcd
         2bCdVggAUiaf/IZT2ykv02z/A+VE6inrQ3BEQTN4jtOK/RPB1z7rV7FLLLAJxhMQfRuL
         Ja/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANaVoXu55ljkpav9SN1pj18NmEH8lx2ewAQtH2fHYB0=;
        b=DXFqATCj+ihOZmN55SJooFydLpGelwqRRJmagWhauRGWpW+0vwQ/6lA7NbOwc9CvNe
         6chuRktUl+j9dWuqJvRJbJoKKipxGebXQHbYohW7Cu0auv1gpapdRQPsusq1MEslISCp
         fli2/TiaF50sUREDixG5/q2zC7MDpDrsV8NcDNr4u5XN0Zjrfsn/f682eqrMYsewzmut
         lxi+Oe/ZUstUlp4mV7V2t38Tn50sYOcsAFuA2WtmtJXDpaMx2sihoJdhyXzXN37fyNMF
         Zno0FC3dP2LUi6HCUss6/Zn6NcsBEMbKZCaTbC+n6f9bPGO+QPfP7VrSRjS+JMuX2+gi
         ombg==
X-Gm-Message-State: AOAM5334ol+NliYWPQEA1x4zKnIFbh0BvRv7rVXjw+FEBDDDXOGEg/fV
        TVVfYdb1zqZ3ZmbJvmNpkvJ0kAsYGe16Ker6OwRBgg==
X-Google-Smtp-Source: ABdhPJxw38x9CvHao9Pj701EVIKxSBumcofay2OZSTdlR9iNK5zF05jfsTPPs8Z5W31klSYYIRTD5Wla2gtOVEuERZQ=
X-Received: by 2002:a54:4515:: with SMTP id l21mr8018083oil.15.1638917271888;
 Tue, 07 Dec 2021 14:47:51 -0800 (PST)
MIME-Version: 1.0
References: <20211207201034.1392660-1-pgonda@google.com>
In-Reply-To: <20211207201034.1392660-1-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 7 Dec 2021 14:47:40 -0800
Message-ID: <CAA03e5G1wMBrP_1+YS2TZxRpcdJQ6CqxRqry8FQpq_PJcCS0jw@mail.gmail.com>
Subject: Re: [PATCH] selftests: sev_migrate_tests: Fix sev_ioctl()
To:     Peter Gonda <pgonda@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 7, 2021 at 12:10 PM Peter Gonda <pgonda@google.com> wrote:
>
> TEST_ASSERT in SEV ioctl was allowing errors because it checked return
> value was good OR the FW error code was OK. This TEST_ASSERT should
> require both (aka. AND) values are OK. Removes the LAUNCH_START from the
> mirror VM because this call correctly fails because mirror VMs cannot
> call this command.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 29b18d565cf4..8e1b1e737cb1 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -31,7 +31,7 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
>         int ret;
>
>         ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> -       TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> +       TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
>                     "%d failed: return code: %d, errno: %d, fw error: %d",
>                     cmd_id, ret, errno, cmd.error);
>  }
> @@ -228,9 +228,6 @@ static void sev_mirror_create(int dst_fd, int src_fd)
>  static void test_sev_mirror(bool es)
>  {
>         struct kvm_vm *src_vm, *dst_vm;
> -       struct kvm_sev_launch_start start = {
> -               .policy = es ? SEV_POLICY_ES : 0
> -       };
>         int i;
>
>         src_vm = sev_vm_create(es);
> @@ -241,7 +238,7 @@ static void test_sev_mirror(bool es)
>         /* Check that we can complete creation of the mirror VM.  */
>         for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
>                 vm_vcpu_add(dst_vm, i);
> -       sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_START, &start);
> +
>         if (es)
>                 sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
>
> --
> 2.34.1.400.ga245620fadb-goog
>

+1 to Sean's feedback.

Otherwise:

Reviewed-by: Marc Orr <marcorr@google.com>
