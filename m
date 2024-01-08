Return-Path: <kvm+bounces-5817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8271E826F6D
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDBDAB21FFA
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E4A44C88;
	Mon,  8 Jan 2024 13:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OAoSGY28"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A156E4174D;
	Mon,  8 Jan 2024 13:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408ClkX7008664;
	Mon, 8 Jan 2024 13:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=TUkqyDZU2w0pJe2IADGbbappcrOnCPRNodexsVKjT+8=;
 b=OAoSGY28pCKHNAjzJrlgLXmSe/AsB4iZf8ugjpTFG0OxcsC9b2DjyRTdaMr24WBfiREm
 4hoGrP1gWHyMMPP7SCH1NIqBCGpRlNp2TsgvICA4c111As3MRU+oCMKQl0OlJvj1IDJS
 zotNXl+5uON9ss4zf/lxkZq6niHLf876crLFvBM2CYHSp55tKW0Pwyr2/eKPi336uqcb
 vENdCWRGiHzXxgr7Do/B98PTdcVUeca4jYTm5Z4dw3UX2t5E/znGqTRtKiQmZD8Go+L3
 tYamG7a3JEwQW/j9j5unqnQRcN9O3pfSvVJDa5rMkFsjrCxAyDo7roMwHO/m/72/SRQj qg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vghc3gnh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:13:30 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408Cm39u009852;
	Mon, 8 Jan 2024 13:13:30 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vghc3gngk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:13:30 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408B6lwk027006;
	Mon, 8 Jan 2024 13:13:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vfkw1qjnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:13:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408DDRDV40501792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 13:13:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8327920049;
	Mon,  8 Jan 2024 13:13:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56CFD20040;
	Mon,  8 Jan 2024 13:13:27 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.166.51])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  8 Jan 2024 13:13:27 +0000 (GMT)
Date: Mon, 8 Jan 2024 14:13:25 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZZv09bLJvA5M/kc7@DESKTOP-2CCOB1S.>
References: <20231209053443-mutt-send-email-mst@kernel.org>
 <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214021328-mutt-send-email-mst@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ECAMvZcC_h-gkpU_Pbp9Ecir0gWIPvvz
X-Proofpoint-GUID: uFGhddQc-GSToOejEHlZ_c_bFqoRBb5C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 mlxlogscore=825 phishscore=0
 clxscore=1011 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401080113

On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> 
> Peter, would appreciate feedback on this. When is cond_resched()
> insufficient to give up the CPU? Should Documentation/kernel-hacking/hacking.rst
> be updated to require schedule() instead?
> 

Happy new year everybody!

I'd like to bring this thread back to life. To reiterate:

- The introduction of the EEVDF scheduler revealed a performance
  regression in a uperf testcase of ~50%.
- Tracing the scheduler showed that it takes decisions which are
  in line with its design.
- The traces showed as well, that a vhost instance might run
  excessively long on its CPU in some circumstance. Those cause
  the performance regression as they cause delay times of 100+ms
  for a kworker which drives the actual network processing.
- Before EEVDF, the vhost would always be scheduled off its CPU
  in favor of the kworker, as the kworker was being woken up and
  the former scheduler was giving more priority to the woken up
  task. With EEVDF, the kworker, as a long running process, is
  able to accumulate negative lag, which causes EEVDF to not
  prefer it on its wake up, leaving the vhost running.
- If the kworker is not scheduled when being woken up, the vhost
  continues looping until it is migrated off the CPU.
- The vhost offers to be scheduled off the CPU by calling 
  cond_resched(), but, the the need_resched flag is not set,
  therefore cond_resched() does nothing.

To solve this, I see the following options 
  (might not be a complete nor a correct list)
- Along with the wakeup of the kworker, need_resched needs to
  be set, such that cond_resched() triggers a reschedule.
- The vhost calls schedule() instead of cond_resched() to give up
  the CPU. This would of course be a significantly stricter
  approach and might limit the performance of vhost in other cases.
- Preventing the kworker from accumulating negative lag as it is
  mostly not runnable and if it runs, it only runs for a very short
  time frame. This might clash with the overall concept of EEVDF.
- On cond_resched(), verify if the consumed runtime of the caller
  is outweighing the negative lag of another process (e.g. the 
  kworker) and schedule the other process. Introduces overhead
  to cond_resched.

I would be curious on feedback on those ideas and interested in
alternative approaches.

