Return-Path: <kvm+bounces-60883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 23BB9C00DE4
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 13:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C501234DA2F
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 11:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319B130E83A;
	Thu, 23 Oct 2025 11:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kb6yKlcH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08D730ACE1
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 11:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761220097; cv=none; b=uwbbhKavCzUIb7WRixPp+Ol8TJBTtc1LnQ/iXMAkjuguAShq/mSBD0lKCSsXUmYXhXqtiMnet2toSPRFMiqxqti+m1qLMy9sCYODaHJa9QA8MSuhuHH+UlLO50fJIZRrjSXC67/tKr3YapoH0T5MHXJQdVCA1BeBkF7+hx33YB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761220097; c=relaxed/simple;
	bh=4evKnE8IwuHOHgrgYiadQ6t7IJFp9maZFhhhaKSp2uM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQ0s/Iw6k6mL8tuvcAeggR7g2OcOmXcRTFlIjagk1xInlvgYc9VoSrHC3cBN6efKCKnZRuKd12anJj/7PP1dhaQAQ30RxjovTogiTy6gMLvvk421OrMxpBH7iXWTI8CSatMJ3MGFBc1XtDtUwXauTXYIeNqZPWAZsYe05JtlwUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kb6yKlcH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N9g5ak003946;
	Thu, 23 Oct 2025 11:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4Zqa0v
	85Z6eJjhNLnjuHesU9geC6XkCwBv0f3ip+vbo=; b=kb6yKlcHaLSYjoYPVSK0Hs
	udTX5TGAhPZ6Lhx1s0CpHVwohtMqiLXtzlFz/i4wU4bQtQY9qNYTosgo3EA1R7lk
	iI+sbn4fWgFPW2ew4O+RtceRAuftodX4RdYAS9d8MWQcqkFi6gjjuP5O1Dr64O80
	k+il1o7LXStbHgQAL5+lKT5rUP8/PPBDOGWVz7GZVwfrQ0WesmBfuheO9Kp1wPSG
	874h31/wJt4y0i1WYmt/yyWWLgwow7SNEho8PBaaDiSjwkMFDg7y98+m4Vw7ZZs/
	xXfldWBybtWohMGX6HB3dvTlG3dYtxnHBYlWfQIVExnkAN1YBSQrti0x7gPYe0eQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hrd00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 11:48:02 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59NBm24s023003;
	Thu, 23 Oct 2025 11:48:02 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hrcyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 11:48:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59NBAD2u002488;
	Thu, 23 Oct 2025 11:48:01 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejna9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 11:48:01 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59NBm05J29688456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 11:48:00 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45BD058061;
	Thu, 23 Oct 2025 11:48:00 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C193C58057;
	Thu, 23 Oct 2025 11:47:57 +0000 (GMT)
Received: from [9.124.221.73] (unknown [9.124.221.73])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Oct 2025 11:47:57 +0000 (GMT)
Message-ID: <00e825dc-4e44-4001-9924-77435ce2ff59@linux.ibm.com>
Date: Thu, 23 Oct 2025 17:17:56 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>, qemu-ppc@nongnu.org,
        Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXxS+oYxdzxhd3
 74xs60lmW35DmTjkRRb+bdu4i80cIPh6Kb7d08yOEm9x7phWNnCP2Em/QWIwl/Ar5WVBfJc+Kj5
 L6pUtUIdV9/uh1AWYlmHU9gQVN6AbYY2dZs0HgvvVdjyesthpuKrojdIX7w8TEmxrmfnsy6lCil
 WJtr3OJYXv/sjdOmYeMW6vklzT/H+Q077eQ3JN5W2RZm+2TSjmsGv7Pof2NHE9Ka0H6/qt2XYRE
 9ZOD6C4MY3daT0KHYt84BjDCwRq7xxzybmdEta3koS8wAFhwmzZ8MWI9JQ/OGsXQ/M2mCPPqKii
 TiGbr0Pn4XJE1anmtUXaexC1XICWahQ1eZZGV+JxceTf6fsrTPoy64QnRNTw6AuMlMNXD2woJ0s
 uO2Gy9W7q0wxCCohvnZVnKERcsvz6w==
X-Authority-Analysis: v=2.4 cv=OrVCCi/t c=1 sm=1 tr=0 ts=68fa15f2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=AHPAAfRtqs9UFnfsTcQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=oH34dK2VZjykjzsv8OSz:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=jd6J4Gguk5HxikPWLKER:22
X-Proofpoint-GUID: 2zBzW8fBvBgXORAKnPFHflbdrcrc3Y8a
X-Proofpoint-ORIG-GUID: ElCUNWUEIT-CDHk6-EjbkGoUucIWTq-6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022



On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
> v2: Rebased on https://lore.kernel.org/qemu-devel/20251009184057.19973-1-harshpb@linux.ibm.com/
> 
> Remove the deprecated pseries-3.0 up to pseries-4.2 machines,
> which are older than 6 years. Remove resulting dead code.
> 
> Harsh Prateek Bora (5):
>    ppc/spapr: remove deprecated machine pseries-3.0
>    ppc/spapr: remove deprecated machine pseries-3.1
>    ppc/spapr: remove deprecated machine pseries-4.0
>    ppc/spapr: remove deprecated machine pseries-4.1
>    ppc/spapr: remove deprecated machine pseries-4.2
> 
> Philippe Mathieu-Daudé (6):
>    hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
>    hw/ppc/spapr: Inline spapr_dtb_needed()
>    hw/ppc/spapr: Inline few SPAPR_IRQ_* uses
>    target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
>    target/ppc/kvm: Remove kvmppc_get_host_model() as unused
>    hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback

Queued and posted PR.
Additional cleanup suggestions on patch 2 can be taken up as a 
follow-up. Thanks.

regards,
Harsh

