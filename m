Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF51F8E0
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 18:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfEOQo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 12:44:57 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35586 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEOQo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 12:44:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id c17so370116lfi.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJOvi18L7fqK+4eFB/vQ8Hw8akTbJRCqM8gnrvSMvQs=;
        b=bTKvpeHfA/y9f0nD0G2wvBnlydD3DkqNv+iHtpU6rlFbyz3nk4VDc96vqzrFsQsUPn
         U3Xsj7BeVtcuZrsHNiVYeIROCBzb7CeBAkzgXAZ2wdW8Q5Vav0YS+fIshjbvuwl5RiPs
         do9JEhNsm34DhRg/afRZu/4CveGjJhU4khSc/Fo72nQDHNL7bheI1kXthh2bbkJXwR8w
         0ZdLlDMcPV3YJ+VjD4quA3f/EAqYWUzHpMd51tEmB3k2buj2kAtpYXzIh+NGmaBdTs7i
         z2zIro74b+kDFSOGlg6ACYvX8afsQfbMVoXdbigrfKkKk0rmXKKbLBZcc7TJUkOkT33i
         BxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJOvi18L7fqK+4eFB/vQ8Hw8akTbJRCqM8gnrvSMvQs=;
        b=kYs5/3tuumokuA3qxN2rWIw/I9tVg9E2RNYe9UN7FPca4Mz/16NUcod7eEL6LUEojc
         uBYU55SY29VgUG2eq7v1StV9aaXoch5MgxUP/Awr0cpBoikySGzDOIGt1r6BnWo6fcGr
         ZP7Uu6018h6vJhwMIzEd27c4sWzWoYNhs2EdBZlvK6Oko6JvVj6wzyblQkIsZ1lRIqJh
         PwmYIrPANPoLWcLHaX4WmIXqku1kMA0YBP/eoHkU8Z3rjpEmGviLwIeFkVsJtdcq7s7O
         Whs7Gav3K+rG80IEMY+sGVI8u7vzaPpwuzw5YhitMWrTqD79c3/GWbQnpxo88ALGSSw3
         oe7g==
X-Gm-Message-State: APjAAAW0Zb/WH7+rUcBVz5bZ5rkz6GKEByUshvJtRSUP2sdth8ymA9wy
        eVA+pIk0NpReMSWCGCVsHbryS5SrwJgrhNGScUty+g==
X-Google-Smtp-Source: APXvYqwXj4idJmJE1DtEImIBJtns+QbL27f5YRYiCBVu3dzN4Bnicdpw+haJRw7uLfsMmZP8j0DFdTZreKxntaSbx+8=
X-Received: by 2002:a19:f817:: with SMTP id a23mr12334507lff.123.1557938694539;
 Wed, 15 May 2019 09:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <1557317799-39866-1-git-send-email-pbonzini@redhat.com>
 <20190508142023.GA13834@linux.intel.com> <CAAAPnDE0ujH4eTX=4umTTEmUMyaZ7M0B3qxWa7oUUD-Ls7Ta+A@mail.gmail.com>
 <20190508181339.GD19656@linux.intel.com> <CAAAPnDF=T8FHqLrHUDB9g9QzWJcct2mddqUW0O7zja7Ae0uy-Q@mail.gmail.com>
In-Reply-To: <CAAAPnDF=T8FHqLrHUDB9g9QzWJcct2mddqUW0O7zja7Ae0uy-Q@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 15 May 2019 09:44:43 -0700
Message-ID: <CAAAPnDHLxRe9htqT9P_G1HufWuxq-+xE+Kff+fhXB6xPRcHNbw@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: nVMX: Set nested_run_pending in
 vmx_set_nested_state after checks complete
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 8, 2019 at 2:13 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Wed, May 8, 2019 at 11:13 AM
> To: Aaron Lewis
> Cc: Paolo Bonzini, <linux-kernel@vger.kernel.org>,
> <kvm@vger.kernel.org>, Peter Shier
>
> > On Wed, May 08, 2019 at 10:53:12AM -0700, Aaron Lewis wrote:
> > > nested_run_pending is also checked in
> > > nested_vmx_check_vmentry_postreqs
> > > (https://elixir.bootlin.com/linux/v5.1/source/arch/x86/kvm/vmx/nested.c#L2709)
> > > so I think the setting needs to be moved to just prior to that call
> > > with Paolo's rollback along with another for if the prereqs and
> > > postreqs fail.  I put a patch together below:
> >
> > Gah, I missed that usage (also, it's now nested_vmx_check_guest_state()).
> >
> > Side topic, I think the VM_ENTRY_LOAD_BNDCFGS check should be gated by
> > nested_run_pending, a la the EFER check.'
> >
> > > ------------------------------------
> > >
> > > nested_run_pending=1 implies we have successfully entered guest mode.
> > > Move setting from external state in vmx_set_nested_state() until after
> > > all other checks are complete.
> > >
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > > Reviewed-by: Peter Shier <pshier@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
> > >  1 file changed, 9 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 6401eb7ef19c..cf1f810223d2 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -5460,9 +5460,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> > >   if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> > >   return 0;
> > >
> > > - vmx->nested.nested_run_pending =
> > > - !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> >
> > Alternatively, it might be better to leave nested_run_pending where it
> > is and instead add a label to handle clearing the flag on error.  IIUC,
> > the real issue is that nested_run_pending is left set after a failed
> > vmx_set_nested_state(), not that its shouldn't be set in the shadow
> > VMCS handling.
> >
> > Patch attached, though it's completely untested.  The KVM selftests are
> > broken for me right now, grrr.
> >
> > > -
> > >   if (nested_cpu_has_shadow_vmcs(vmcs12) &&
> > >       vmcs12->vmcs_link_pointer != -1ull) {
> > >   struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
> > > @@ -5480,14 +5477,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> > >   return -EINVAL;
> > >   }
> > >
> > > + vmx->nested.nested_run_pending =
> > > + !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> > > +
> > >   if (nested_vmx_check_vmentry_prereqs(vcpu, vmcs12) ||
> > > -     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
> > > +     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual)) {
> > > +     vmx->nested.nested_run_pending = 0;
> > >   return -EINVAL;
> > > + }
> > >
> > >   vmx->nested.dirty_vmcs12 = true;
> > >   ret = nested_vmx_enter_non_root_mode(vcpu, false);
> > > - if (ret)
> > > + if (ret) {
> > > + vmx->nested.nested_run_pending = 0;
> > >   return -EINVAL;
> > > + }
> > >
> > >   return 0;
> > >  }
>
> Here is an update based on your patch.  I ran these changes against
> the test vmx_set_nested_state_test, and it run successfully.
>
> That's correct that we are only concerned about restoring the state of
> nested_run_pending, so it's fine to set it where we do as long as we
> back the state change out before returning if we get an error.
>
> ---------------------------------------------
>
> nested_run_pending=1 implies we have successfully entered guest mode.
> Move setting from external state in vmx_set_nested_state() until after
> all other checks are complete.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Tested-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6401eb7ef19c..fe5814df5149 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5468,28 +5468,36 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
>
>   if (kvm_state->size < sizeof(kvm_state) + 2 * sizeof(*vmcs12))
> - return -EINVAL;
> + goto error_guest_mode_einval;
>
>   if (copy_from_user(shadow_vmcs12,
>      user_kvm_nested_state->data + VMCS12_SIZE,
> -    sizeof(*vmcs12)))
> - return -EFAULT;
> +    sizeof(*vmcs12))) {
> + ret = -EFAULT;
> + goto error_guest_mode;
> + }
>
>   if (shadow_vmcs12->hdr.revision_id != VMCS12_REVISION ||
>       !shadow_vmcs12->hdr.shadow_vmcs)
> - return -EINVAL;
> + goto error_guest_mode_einval;
>   }
>
>   if (nested_vmx_check_vmentry_prereqs(vcpu, vmcs12) ||
>       nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
> - return -EINVAL;
> + goto error_guest_mode_einval;
>
>   vmx->nested.dirty_vmcs12 = true;
>   ret = nested_vmx_enter_non_root_mode(vcpu, false);
>   if (ret)
> - return -EINVAL;
> + goto error_guest_mode_einval;
>
>   return 0;
> +
> +error_guest_mode_einval:
> + ret = -EINVAL;
> +error_guest_mode:
> + vmx->nested.nested_run_pending = 0;
> + return ret;
>  }
>
>  void nested_vmx_vcpu_setup(void)

Sean, I updated this patch based on the one you sent out.  Does it
look good now?
