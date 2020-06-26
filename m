Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC0820B72B
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 19:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgFZRh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 13:37:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56106 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgFZRh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 13:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593193075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fyws02fLz3vFP4WruqNyiJlcETyOe6KDZOHSeNYTwDU=;
        b=dRs0GVOvM+xtVkiee/4vqA9Vwp4+q8K7HGFE7OZqHxvMekHOWKNCtNO2YaaJ84cx1hkrRW
        2BHSGEwwblmopClcoLNpmZxMoBzKcvSBTotSC27IXdRv/iNL8r2b2EAgzSTocNSgozds5M
        xPuiTQ4W1BMVvPnZSKqBnkVAd+Zgo4c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-obixYrbhMeuID-HEBrkjeQ-1; Fri, 26 Jun 2020 13:37:53 -0400
X-MC-Unique: obixYrbhMeuID-HEBrkjeQ-1
Received: by mail-qk1-f199.google.com with SMTP id s75so7156745qka.1
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 10:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fyws02fLz3vFP4WruqNyiJlcETyOe6KDZOHSeNYTwDU=;
        b=WRws5IJLTS8dUkX80chKyPokQjBFC+DIKyeNqG4ywfslgckcmhhNLeFzCoZMM7fzh9
         d9W86xwzrpYl9psbJzYYbciaqQDi/IFNJC4R88Vuq97cYQquK+AOu8EfV1myPFojdIHB
         uKZaw0pnXhjPEt98T0AFIrd4vMJUCNhm8XTNyOTvZmHJCgMO687mSnHn35FumiB6Nu6+
         B0AWTFBkX88sAhzOlYqnYwja7RqKDQ+crd0dnu1y1+OHPQvxKaXb4V4vnTprWwBvOiOQ
         dJ9+MzIxkxgFhlnIZc2/FFIF964bFi3wq9j+LWbfD0XbVPnUqQkK5MMjXQPjQ5dHbY1I
         rJBw==
X-Gm-Message-State: AOAM531qGbAOwBxdAZERDaG45948QhR6DEqANwLAJBR71KDrW8GbRkSG
        NfQE4fPAZrYeFSuAEtJ7e28woKpolYuSBQCwy7HeCpUaBqpgJpiqwNS/UoeY3NpWLvJ+6oew+Bt
        rFvz5lasK54N0
X-Received: by 2002:ac8:3528:: with SMTP id y37mr3932649qtb.308.1593193073402;
        Fri, 26 Jun 2020 10:37:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCjiss13XM/Mi86v8m2KXOv1zy/29jTkRJ4pMfL9LzwqwqinbO63hC+WtdwXeCbrDYcCRPow==
X-Received: by 2002:ac8:3528:: with SMTP id y37mr3932632qtb.308.1593193073163;
        Fri, 26 Jun 2020 10:37:53 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id b22sm7937935qka.43.2020.06.26.10.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 10:37:52 -0700 (PDT)
Date:   Fri, 26 Jun 2020 13:37:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200626173750.GA175520@xz-x1>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <df859fb0-a665-a82a-0cf1-8db95179cb74@redhat.com>
 <20200626155657.GC6583@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200626155657.GC6583@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 26, 2020 at 08:56:57AM -0700, Sean Christopherson wrote:
> Not really?  It's solving a problem that doesn't exist in the current code
> base (assuming TSC_CTRL is fixed), and IMO solving it in an ugly fashion.
> 
> I would much prefer that, _if_ we want to support blind KVM-internal MSR
> accesses, we end up with code like:
> 
> 	if (msr_info->kvm_internal) {
> 		return 1;
> 	} else if (!ignore_msrs) {
> 		vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
> 			    msr, data);
> 		return 1;
> 	} else {
> 		if (report_ignored_msrs)
> 			vcpu_unimpl(vcpu,
> 				"ignored wrmsr: 0x%x data 0x%llx\n",
> 				msr, data);
> 		break;
> 	}
> 
> But I'm still not convinced that there is a legimiate scenario for setting
> kvm_internal=true.

Actually this really looks like my initial version when I was discussing this
with Paolo before this version, but Paolo suggested what I implemented last.  I
think I agree with Paolo that it's an improvement to have a way to get/set real
msr value so that we don't need to further think about effects being taken with
the two tricky msr knobs (report_ignored_msrs, ignore_msrs).  These knobs are
even trickier to me when they're hidden deep, because they are not easily
expected when seeing the name of the functions (e.g. __kvm_set_msr, rather than
__kvm_set_msr_retval_fixed).

Thanks,

-- 
Peter Xu

