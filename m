Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEE06F0500
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 13:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbjD0L17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 07:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243416AbjD0L14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 07:27:56 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA462120;
        Thu, 27 Apr 2023 04:27:54 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R9fLq9006633;
        Thu, 27 Apr 2023 11:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=BE92gzCqC+C4Ky9wpJ6eiYG+0iVQbu2mCeiXeWkkpfo=;
 b=aP7fACfuc7+kI+0tJValOSrHvL15W9P1diOSgk5CBHKwoeDhU/ymGm1an/zwrRU1A0/G
 tvjkHClGmpgiJ2LowpYG8M8CxkkK+GvVy+g1Xw6Q/LkBQq8Z7DHya1dorosqXIHn1aAG
 Vv20QJuwjlf2fxplmIUZigG7lcH0m0x2/R1V9daqVpvq+XvC1ONE5p1V1O/7ae5JBC+A
 7foEQdS4qpGSB0PdXR/Fw8UMlbNAgeQ3M9eIXU5tOkmFMSKvJByjJofx5wuWJ7VivsQS
 jyNLTYGMY7iPQq7VW2PaavXMAAmepivGGRDunZ+w5jy4mlNolJ7vd0ErcN7RCcPpkTQG /Q== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q7m4y8kqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 11:27:19 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33RBRHmr031560
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 11:27:17 GMT
Received: from hu-pkondeti-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 27 Apr 2023 04:27:01 -0700
Date:   Thu, 27 Apr 2023 16:56:57 +0530
From:   Pavan Kondeti <quic_pkondeti@quicinc.com>
To:     "Gupta, Pankaj" <pankaj.gupta@amd.com>
CC:     Pavan Kondeti <quic_pkondeti@quicinc.com>,
        David Dai <davidai@google.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        "Sudeep Holla" <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>,
        "Mel Gorman" <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        <kernel-team@android.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <20230427112657.GA398143@hu-pkondeti-hyd.qualcomm.com>
References: <20230330224348.1006691-1-davidai@google.com>
 <20230427074602.GA325349@hu-pkondeti-hyd.qualcomm.com>
 <4eed40a7-d927-1b0c-b19b-9bb5b3083b73@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4eed40a7-d927-1b0c-b19b-9bb5b3083b73@amd.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ryfOhFsOQxrMKwtftZ-ynjdmARDJT1sV
X-Proofpoint-ORIG-GUID: ryfOhFsOQxrMKwtftZ-ynjdmARDJT1sV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 spamscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270100
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 27, 2023 at 11:52:29AM +0200, Gupta, Pankaj wrote:
> 
> > > This patch series is a continuation of the talk Saravana gave at LPC 2022
> > > titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
> > > of the talk is that workloads running in a guest VM get terrible task
> > > placement and DVFS behavior when compared to running the same workload in
> > > the host. Effectively, no EAS for threads inside VMs. This would make power
> > > and performance terrible just by running the workload in a VM even if we
> > > assume there is zero virtualization overhead.
> > > 
> > > We have been iterating over different options for communicating between
> > > guest and host, ways of applying the information coming from the
> > > guest/host, etc to figure out the best performance and power improvements
> > > we could get.
> > > 
> > > The patch series in its current state is NOT meant for landing in the
> > > upstream kernel. We are sending this patch series to share the current
> > > progress and data we have so far. The patch series is meant to be easy to
> > > cherry-pick and test on various devices to see what performance and power
> > > benefits this might give for others.
> > > 
> > > With this series, a workload running in a VM gets the same task placement
> > > and DVFS treatment as it would when running in the host.
> > > 
> > > As expected, we see significant performance improvement and better
> > > performance/power ratio. If anyone else wants to try this out for your VM
> > > workloads and report findings, that'd be very much appreciated.
> > > 
> > > The idea is to improve VM CPUfreq/sched behavior by:
> > > - Having guest kernel to do accurate load tracking by taking host CPU
> > >    arch/type and frequency into account.
> > > - Sharing vCPU run queue utilization information with the host so that the
> > >    host can do proper frequency scaling and task placement on the host side.
> > > 
> > 
> > [...]
> > 
> > > 
> > > Next steps:
> > > ===========
> > > We are continuing to look into communication mechanisms other than
> > > hypercalls that are just as/more efficient and avoid switching into the VMM
> > > userspace. Any inputs in this regard are greatly appreciated.
> > > 
> > 
> > I am trying to understand why virtio based cpufrq does not work here?
> > The VMM on host can process requests from guest VM like freq table,
> > current frequency and setting the min_freq. I believe Virtio backend
> > has mechanisms for acceleration (vhost) so that user space is not
> > involved for every frequency request from the guest.
> > 
> > It has advantages of (1) Hypervisor agnostic (virtio basically)
> > (2) scheduler does not need additional input, the aggregated min_freq
> > requests from all guest should be sufficient.
> 
> Also want to add, 3) virtio based solution would definitely be better from
> performance POV as would avoid expense vmexits which we have with
> hypercalls.
> 
> 
I just went through the whole discussion, it seems David mentioned he would
re-write this series with virtio frontend and VMM in user space taking
care of the requests. will wait for that series to land.

Thanks,
Pavan
