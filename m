Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947A011EEE9
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 00:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLMXzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 18:55:40 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42729 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMXzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 18:55:40 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so244610pgb.9
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 15:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=arWkzCDbA8bbnBrS+cFnTvcK2MC/4mYbE0ahnpgnOq4=;
        b=hGUM/RE1cmaCUwc9fPorhPjtv3zLlsuWNqJSLwk/wPZzQ1ERpmeXOuGtA5dhwGp1li
         hBE0x6dVaF3IEax7pX4tk3Wc4lAJdf1vi03dt0jfvPxXpuCiASm7mnUM47bK7vuqp8PC
         YGirHZa7P2C4XG9wg+EyJFVGD+xYlBN4Xfsi4qHlYDsIJLeCZQcF5d4i/i12lr8tVpi0
         1896T5tq9wVoWgKQU5fiXshozl05QUuI8RdVUfRIt6/rSGe0YqJF/loiVCSKZ9ck7inJ
         hmFs+UY+WFGLlnNUhnyaalKavqgikCmc+BiF5HIf1je0MWnx4tMXxJyVM1yWi16dy4FU
         BRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=arWkzCDbA8bbnBrS+cFnTvcK2MC/4mYbE0ahnpgnOq4=;
        b=hblnbrR1aTKeltdX0K25p/alYo9klgWCTfstFt4upyJG4u0pLDKcyMVR/nTKXTvmnB
         czJitbtO5va1NMNK8zYwUnXht/v/fBd3b5uPOqZnE1dKMiOIAO+SEMPPG5a8ovbDlhif
         p75gWJseXsqN7ZOgZiqMBjWLQhSu1vtWzN4aBhCPxfmsD4eSPkPjm4lxH/H3uaSsw1SK
         HoEypP7uZAwu2RiI7S/vbqCepOn/k9i3oUbyzPoxasOcgRN1RgLF2by5GcAfsoVRTFnr
         Y61dS8tpszYBix4dF5/MwqrdKocHERUkXGAQhD7N1WQNwAz5qCvnM9lA35X+uUgse0R8
         GEGQ==
X-Gm-Message-State: APjAAAX8u43QsNPXTelPW1JwkPyfANfPANg58TFpAaXxTS2ErJO7Q2XU
        uiGILMDrLp7ZndK1FOiCuHaTzIVA68E=
X-Google-Smtp-Source: APXvYqycGBBN8M0I7Lk6nO6zo7VVfwqVx9IcqO7ftzVxRj0j9LkbqwGRsheb3opifmyV8fxur7w6Lw==
X-Received: by 2002:a62:5bc4:: with SMTP id p187mr2432545pfb.255.1576281339116;
        Fri, 13 Dec 2019 15:55:39 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id p5sm11863721pgs.28.2019.12.13.15.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 15:55:38 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:55:34 -0800
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Use SET_MSR_OR_WARN() to simplify failure
 logging
Message-ID: <20191213235534.GA55046@google.com>
References: <20191128094609.22161-1-oupton@google.com>
 <20191202212148.GA8120@linux.intel.com>
 <2070ffde-5724-df7e-4845-1a4eac129756@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2070ffde-5724-df7e-4845-1a4eac129756@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 01:43:27AM +0100, Paolo Bonzini wrote:
> On 02/12/19 22:21, Sean Christopherson wrote:
> > As for the original code, arguably it *should* do a full WARN and not
> > simply log the error, as kvm_set_msr() should never fail if
> > VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL was exposed to L1, unlike the above two
> > cases where KVM is processing an L1-controlled MSR list, e.g.:
> > 
> > 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> > 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> > 					 vmcs12->host_ia32_perf_global_ctrl));
> > 
> > Back to this patch, this isn't simply consolidating code, it's promoting
> > L1-controlled messages from pr_debug() to pr_warn().
> > 
> > What if you add a patch to remove SET_MSR_OR_WARN() and instead manually
> > do the WARN_ON_ONCE() as above, and then introduce a new macro to
> > consolidate the pr_debug_ratelimited() stuff in this patch?

Sean,

Thank you for the detailed review of this patch (as well as the last one
that I snuck past you :-P). I'm in complete agreement with your
sentiments, a follow-up is in order. I'll get that out soon.

> Should go without saying (Sean is a Certified Reviewer according to
> MAINTAINERS :)) but I agree.
> 
> Paolo

Sean has been a great help in providing detailed reviews -- well
deserving of the designation! Thank you for pinging this thread, Paolo.

--
Best,
Oliver

