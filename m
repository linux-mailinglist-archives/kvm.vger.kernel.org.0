Return-Path: <kvm+bounces-26164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DBB797252F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB273B235E3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B3418CBFA;
	Mon,  9 Sep 2024 22:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZor9CGG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31C18030;
	Mon,  9 Sep 2024 22:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920243; cv=none; b=V6NS5Nnz63getE6Mkoc6FZq0nZgBYR5YyB1u2j/zxYKT4gwStUIydti4xHyBPnhZr0Ab0BgLDt/uxLy3MTlsKZ1T4dCFjZ2/3BO6xrqChoBj65Jo7BFa1vSvNKVx1fdnew2gLVB+7OjpWtV2hUxu4gMWMhHMRCuF8InUuZRQy8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920243; c=relaxed/simple;
	bh=7xNmkX1MrzhkG29N4fJyIOYP9GKZjbL/6Nc9BXH8PbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4AbaBkoDHnhePC0zpNjaHCfCEPasVWkFmNl3eq0mvyHF97IG2bRJkZiYj8vCJiepuGnwSPpseNqXnihOAOtryMQTBC2tJpqaxhaY+zCX7wY8JUUDBLEveUFtKLkYH3AVoji9H4Mh2khQIcDB6OTrbLwQM8jZNFH++pi3HYjPN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZor9CGG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D53EC4CEC5;
	Mon,  9 Sep 2024 22:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725920242;
	bh=7xNmkX1MrzhkG29N4fJyIOYP9GKZjbL/6Nc9BXH8PbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZor9CGGAl7jRy3t39usihS6sEn3qjidalH2YNkNAWzWfazPphNqsJy/qj67ZtFPu
	 DZck1N8vaCuB7sV08I14IkEJYJRJS72au+4NWpiODv+ToHyhjZBFOqG4rvi3vVoQcU
	 WUAibgtFttLhKTJemWrRCuUvJd7CGk3o3OixWqAYolnhE+d3KpJT1cTay7ERamEiB4
	 AlLMq7xcjUrc8/xBJQgOA7daNoolJQL6UrMFZ1asfwp45BPYuSpTUh0mWvirUuLYy1
	 T515rK3MWkYCu7jJbvTgBfuSwRXIXDs7pscwwtmqoFDGtzsI6Ea+62bTcwdPKvGd4J
	 rRtmaIH+3Mr+w==
Date: Mon, 9 Sep 2024 15:17:20 -0700
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 06/58] perf: Support get/put passthrough PMU
 interfaces
Message-ID: <Zt9z8J4wD2VXe2sE@google.com>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-7-mizhang@google.com>
 <f7b2c537-840d-4043-944e-59926f0fa3bb@linux.intel.com>
 <a585d90b-91f4-49de-bcba-5c2b45d339bc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a585d90b-91f4-49de-bcba-5c2b45d339bc@linux.intel.com>

Hello,

On Fri, Sep 06, 2024 at 11:40:51AM -0400, Liang, Kan wrote:
> 
> 
> On 2024-09-06 6:59 a.m., Mi, Dapeng wrote:
> > 
> > On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> >> From: Kan Liang <kan.liang@linux.intel.com>
> >>
> >> Currently, the guest and host share the PMU resources when a guest is
> >> running. KVM has to create an extra virtual event to simulate the
> >> guest's event, which brings several issues, e.g., high overhead, not
> >> accuracy and etc.
> >>
> >> A new passthrough PMU method is proposed to address the issue. It requires
> >> that the PMU resources can be fully occupied by the guest while it's
> >> running. Two new interfaces are implemented to fulfill the requirement.
> >> The hypervisor should invoke the interface while creating a guest which
> >> wants the passthrough PMU capability.
> >>
> >> The PMU resources should only be temporarily occupied as a whole when a
> >> guest is running. When the guest is out, the PMU resources are still
> >> shared among different users.
> >>
> >> The exclude_guest event modifier is used to guarantee the exclusive
> >> occupation of the PMU resources. When creating a guest, the hypervisor
> >> should check whether there are !exclude_guest events in the system.
> >> If yes, the creation should fail. Because some PMU resources have been
> >> occupied by other users.
> >> If no, the PMU resources can be safely accessed by the guest directly.
> >> Perf guarantees that no new !exclude_guest events are created when a
> >> guest is running.
> >>
> >> Only the passthrough PMU is affected, but not for other PMU e.g., uncore
> >> and SW PMU. The behavior of those PMUs are not changed. The guest
> >> enter/exit interfaces should only impact the supported PMUs.
> >> Add a new PERF_PMU_CAP_PASSTHROUGH_VPMU flag to indicate the PMUs that
> >> support the feature.
> >>
> >> Add nr_include_guest_events to track the !exclude_guest events of PMU
> >> with PERF_PMU_CAP_PASSTHROUGH_VPMU.
> >>
> >> Suggested-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> >> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> >> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >> ---
> >>  include/linux/perf_event.h | 10 ++++++
> >>  kernel/events/core.c       | 66 ++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 76 insertions(+)
> >>
> >> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> >> index a5304ae8c654..45d1ea82aa21 100644
> >> --- a/include/linux/perf_event.h
> >> +++ b/include/linux/perf_event.h
> >> @@ -291,6 +291,7 @@ struct perf_event_pmu_context;
> >>  #define PERF_PMU_CAP_NO_EXCLUDE			0x0040
> >>  #define PERF_PMU_CAP_AUX_OUTPUT			0x0080
> >>  #define PERF_PMU_CAP_EXTENDED_HW_TYPE		0x0100
> >> +#define PERF_PMU_CAP_PASSTHROUGH_VPMU		0x0200
> >>  
> >>  struct perf_output_handle;
> >>  
> >> @@ -1728,6 +1729,8 @@ extern void perf_event_task_tick(void);
> >>  extern int perf_event_account_interrupt(struct perf_event *event);
> >>  extern int perf_event_period(struct perf_event *event, u64 value);
> >>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
> >> +int perf_get_mediated_pmu(void);
> >> +void perf_put_mediated_pmu(void);
> >>  #else /* !CONFIG_PERF_EVENTS: */
> >>  static inline void *
> >>  perf_aux_output_begin(struct perf_output_handle *handle,
> >> @@ -1814,6 +1817,13 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
> >>  {
> >>  	return 0;
> >>  }
> >> +
> >> +static inline int perf_get_mediated_pmu(void)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +static inline void perf_put_mediated_pmu(void)			{ }
> >>  #endif
> >>  
> >>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
> >> diff --git a/kernel/events/core.c b/kernel/events/core.c
> >> index 8f908f077935..45868d276cde 100644
> >> --- a/kernel/events/core.c
> >> +++ b/kernel/events/core.c
> >> @@ -402,6 +402,20 @@ static atomic_t nr_bpf_events __read_mostly;
> >>  static atomic_t nr_cgroup_events __read_mostly;
> >>  static atomic_t nr_text_poke_events __read_mostly;
> >>  static atomic_t nr_build_id_events __read_mostly;
> >> +static atomic_t nr_include_guest_events __read_mostly;
> >> +
> >> +static atomic_t nr_mediated_pmu_vms;
> >> +static DEFINE_MUTEX(perf_mediated_pmu_mutex);
> >> +
> >> +/* !exclude_guest event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
> >> +static inline bool is_include_guest_event(struct perf_event *event)
> >> +{
> >> +	if ((event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) &&
> >> +	    !event->attr.exclude_guest)
> >> +		return true;
> >> +
> >> +	return false;
> >> +}
> >>  
> >>  static LIST_HEAD(pmus);
> >>  static DEFINE_MUTEX(pmus_lock);
> >> @@ -5212,6 +5226,9 @@ static void _free_event(struct perf_event *event)
> >>  
> >>  	unaccount_event(event);
> >>  
> >> +	if (is_include_guest_event(event))
> >> +		atomic_dec(&nr_include_guest_events);
> >> +
> >>  	security_perf_event_free(event);
> >>  
> >>  	if (event->rb) {
> >> @@ -5769,6 +5786,36 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
> >>  }
> >>  EXPORT_SYMBOL_GPL(perf_event_pause);
> >>  
> >> +/*
> >> + * Currently invoked at VM creation to
> >> + * - Check whether there are existing !exclude_guest events of PMU with
> >> + *   PERF_PMU_CAP_PASSTHROUGH_VPMU
> >> + * - Set nr_mediated_pmu_vms to prevent !exclude_guest event creation on
> >> + *   PMUs with PERF_PMU_CAP_PASSTHROUGH_VPMU
> >> + *
> >> + * No impact for the PMU without PERF_PMU_CAP_PASSTHROUGH_VPMU. The perf
> >> + * still owns all the PMU resources.
> >> + */
> >> +int perf_get_mediated_pmu(void)
> >> +{
> >> +	guard(mutex)(&perf_mediated_pmu_mutex);
> >> +	if (atomic_inc_not_zero(&nr_mediated_pmu_vms))
> >> +		return 0;
> >> +
> >> +	if (atomic_read(&nr_include_guest_events))
> >> +		return -EBUSY;
> >> +
> >> +	atomic_inc(&nr_mediated_pmu_vms);
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
> >> +
> >> +void perf_put_mediated_pmu(void)
> >> +{
> >> +	atomic_dec(&nr_mediated_pmu_vms);
> >> +}
> >> +EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
> >> +
> >>  /*
> >>   * Holding the top-level event's child_mutex means that any
> >>   * descendant process that has inherited this event will block
> >> @@ -11907,6 +11954,17 @@ static void account_event(struct perf_event *event)
> >>  	account_pmu_sb_event(event);
> >>  }
> >>  
> >> +static int perf_account_include_guest_event(void)
> >> +{
> >> +	guard(mutex)(&perf_mediated_pmu_mutex);
> >> +
> >> +	if (atomic_read(&nr_mediated_pmu_vms))
> >> +		return -EACCES;
> > 
> > Kan, Namhyung posted a patchset
> > https://lore.kernel.org/all/20240904064131.2377873-1-namhyung@kernel.org/
> > which would remove to set exclude_guest flag from perf tools by default.
> > This may impact current mediated vPMU solution, but fortunately the
> > patchset provides a fallback mechanism to add exclude_guest flag if kernel
> > returns "EOPNOTSUPP".
> > 
> > So we'd better return "EOPNOTSUPP" instead of "EACCES" here. BTW, returning
> > "EOPNOTSUPP" here looks more reasonable than "EACCES".
> 
> It seems the existing Apple M1 PMU has ready returned "EOPNOTSUPP" for
> the !exclude_guest. Yes, we should use the same error code.

Yep, it'd be much easier to handle if it returns the same error code.

Thanks,
Namhyung


