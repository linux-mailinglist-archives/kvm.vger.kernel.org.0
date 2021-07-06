Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6F3BDF81
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGFWxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 18:53:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:31331 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhGFWxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 18:53:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="196488367"
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="196488367"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 15:50:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="627825471"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by orsmga005.jf.intel.com with ESMTP; 06 Jul 2021 15:50:53 -0700
Date:   Tue, 6 Jul 2021 15:51:27 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Victor Ding <victording@google.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Anand K Mistry <amistry@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] x86/tsx: Add cmdline tsx=fake to not clear CPUID
 bits RTM and HLE
Message-ID: <20210706225127.kyn7amrln6ydfcig@gupta-dev2.localdomain>
References: <cover.2d906c322f72ec1420955136ebaa7a4c5073917c.1623272033.git-series.pawan.kumar.gupta@linux.intel.com>
 <de6b97a567e273adff1f5268998692bad548aa10.1623272033.git-series.pawan.kumar.gupta@linux.intel.com>
 <20210706195233.h6w4cm73oktfqpgz@habkost.net>
 <20210706211606.ezme3xvwztagbjqy@gupta-dev2.localdomain>
 <CAOpTY_pmNah_OCzk3XRyTsgkCPdJD1tp2RxKHMieFQM1s-tQNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOpTY_pmNah_OCzk3XRyTsgkCPdJD1tp2RxKHMieFQM1s-tQNA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.07.2021 17:19, Eduardo Habkost wrote:
>On Tue, Jul 6, 2021 at 5:15 PM Pawan Gupta
><pawan.kumar.gupta@linux.intel.com> wrote:
>>
>> On 06.07.2021 15:52, Eduardo Habkost wrote:
>> >On Wed, Jun 09, 2021 at 02:14:39PM -0700, Pawan Gupta wrote:
>> >> On CPUs that deprecated TSX, clearing the enumeration bits CPUID.RTM and
>> >> CPUID.HLE may not be desirable in some corner cases. Like a saved guest
>> >> would refuse to resume if it was saved before the microcode update
>> >> that deprecated TSX.
>> >
>> >Why is a global option necessary to allow those guests to be
>> >resumed?  Why can't KVM_GET_SUPPORTED_CPUID always return the HLE
>> >and RTM bits as supported when the host CPU has them?
>>
>> Yes, the global option is unnecessary and this patch was dropped in v2.
>
>Was the behaviour this patch originally tried to fix changed in v2 as
>well? Is it going to be possible to resume a HLE=1,RTM=1 VM on a
>TSX_FORCE_ABORT=1 host with no extra kernel command line options
>needed?

The problem it tried to solve is still present, but the global switch
was thought to be unnecessary. I see that Paolo has some suggestions to
fix this in the userspace.

Thanks,
Pawan
