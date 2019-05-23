Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFE8278F4
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 11:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEWJNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 05:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfEWJNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 05:13:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 058C68830F;
        Thu, 23 May 2019 09:13:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FD6562516;
        Thu, 23 May 2019 09:13:12 +0000 (UTC)
Date:   Thu, 23 May 2019 11:13:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>, rkrcmar@redhat.com,
        jmattson@google.com, marcorr@google.com, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 3/3] tests: kvm: Add tests for KVM_SET_NESTED_STATE
Message-ID: <20190523091310.ebvinjwxz6ms5d32@kamzik.brq.redhat.com>
References: <20190502183141.258667-1-aaronlewis@google.com>
 <120edfea-4200-8ab9-981b-d49cfea02d5d@redhat.com>
 <5e068c9b-570b-07ff-8af7-65b0d3f49174@redhat.com>
 <f55847d3-bc5a-1928-e912-ad332c4e641d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f55847d3-bc5a-1928-e912-ad332c4e641d@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 23 May 2019 09:13:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 03:28:22PM +0200, Paolo Bonzini wrote:
> On 20/05/19 15:07, Thomas Huth wrote:
> > On 08/05/2019 14.05, Paolo Bonzini wrote:
> >> On 02/05/19 13:31, Aaron Lewis wrote:
> >>> Add tests for KVM_SET_NESTED_STATE and for various code paths in its implementation in vmx_set_nested_state().
> >>>
> >>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>> Reviewed-by: Marc Orr <marcorr@google.com>
> >>> Reviewed-by: Peter Shier <pshier@google.com>
> >>> ---
> >>>  tools/testing/selftests/kvm/.gitignore        |   1 +
> >>>  tools/testing/selftests/kvm/Makefile          |   1 +
> >>>  .../testing/selftests/kvm/include/kvm_util.h  |   4 +
> >>>  tools/testing/selftests/kvm/lib/kvm_util.c    |  32 ++
> >>>  .../kvm/x86_64/vmx_set_nested_state_test.c    | 275 ++++++++++++++++++
> >>>  5 files changed, 313 insertions(+)
> >>>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> >>>
> >>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> >>> index 2689d1ea6d7a..bbaa97dbd19e 100644
> >>> --- a/tools/testing/selftests/kvm/.gitignore
> >>> +++ b/tools/testing/selftests/kvm/.gitignore
> >>> @@ -6,4 +6,5 @@
> >>>  /x86_64/vmx_close_while_nested_test
> >>>  /x86_64/vmx_tsc_adjust_test
> >>>  /x86_64/state_test
> >>> +/x86_64/vmx_set_nested_state_test
> >>>  /dirty_log_test
> >>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> >>> index f8588cca2bef..10eff4317226 100644
> >>> --- a/tools/testing/selftests/kvm/Makefile
> >>> +++ b/tools/testing/selftests/kvm/Makefile
> >>> @@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> >>>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> >>>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >>>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> >>>  TEST_GEN_PROGS_x86_64 += dirty_log_test
> >>>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
> >>>  
> >>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> >>> index 07b71ad9734a..8c6b9619797d 100644
> >>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> >>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> >>> @@ -118,6 +118,10 @@ void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
> >>>  		     struct kvm_vcpu_events *events);
> >>>  void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>>  		     struct kvm_vcpu_events *events);
> >>> +void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
> >>> +			   struct kvm_nested_state *state);
> >>> +int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>> +			  struct kvm_nested_state *state, bool ignore_error);
> >>>  
> > [...]
> >>
> >> Queued all three, thanks.
> > 
> > struct kvm_nested_state is only declared on x86 ... so this currently
> > fails for me when compiling the kvm selftests for s390x:
> > 
> > include/kvm_util.h:124:14: warning: ‘struct kvm_nested_state’ declared
> > inside parameter list will not be visible outside of this definition or
> > declaration
> >        struct kvm_nested_state *state);
> >               ^~~~~~~~~~~~~~~~
> > include/kvm_util.h:126:13: warning: ‘struct kvm_nested_state’ declared
> > inside parameter list will not be visible outside of this definition or
> > declaration
> >       struct kvm_nested_state *state, bool ignore_error);
> >              ^~~~~~~~~~~~~~~~
> > 
> > ... so I guess these functions should be wrapped with "#ifdef __x86_64__" ?
> 
> Yes, please.
>

Yes, this breaks the aarch64 compile. Awaiting Thomas' patch.

Thanks,
drew 
