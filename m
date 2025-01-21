Return-Path: <kvm+bounces-36093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7C6A179AD
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 09:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69CC166854
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 08:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086841BBBDC;
	Tue, 21 Jan 2025 08:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QAMM4wuN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10DD2AF0A;
	Tue, 21 Jan 2025 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737449909; cv=none; b=sEPOIzxduAUiZ0MIb5xot5fbC1EdKtV0C12s9+Ln3Zx8mM9VesCZr6qA4VdmFrmgPTFE6Q61RVuMN6vfiEXdEnXh0pkINn2JqqS7knoIFq1yYcPadlUsM5d1hG6V+jtVmiBVcdAnWPmj0nILB1JEwGriJQk7TDxbjr5EXnSeu/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737449909; c=relaxed/simple;
	bh=mLLttTnCGnrhCLMys/mhpDPjhuF7ZpAqTOIy41xTAp0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JwAtcMxFO8S8Cwp+hYCn+j1MkVg972WGQ3BPuFXPiNsXNcGzRFftQZ04qxMgVpoEoB4Dj8PbplHEtOeSoqJ13oc4limEBBu94ouawqLwwpHLGZ5YBlgZ8/1/nlMaxy0vjEmTJ8Ve9enxAaLRJ5x6N7KprLh5410Wex4y6ummLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QAMM4wuN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50L5OZ7P011974;
	Tue, 21 Jan 2025 08:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Vyv1mk9effkSJJ0HMvW/9TSrt9PIK4
	5C0Tnf7xODBu8=; b=QAMM4wuNs6KGMB/XyR7WBe5dweMBpjobo1vbLYgqC9IrFY
	VY0TnDKeYZPF6SXBJqjJDpX8XBrURbQJap9wdRnJFeHqU/hP3ml9SCquIfy/q3Tq
	e1YMi6y99HTJGYh98OgVp/FE6D5fBiOe+Ule3Um5SRnuRrPSbrFADbt53xT1zkMt
	56RsGbBeBeERKbQFF+mM/B7h7EddC9SfEZNRn/XI/vR3KHu+onJoEdgVU+Ja8/Mc
	WK4ibeAgfNIWfGgLCWdsx+0nRsf7S38sDUQScZmBV6ouGrFGBMLDZc/gQ1+AS6qS
	f0K8AZBW6UL3prYplzV8gzpFAX6QhiUN31j4sM1Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a5d7gujr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 08:58:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50L5GO88024231;
	Tue, 21 Jan 2025 08:58:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448q0y2ev4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 08:58:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50L8wJbp60555760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 08:58:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA7912004B;
	Tue, 21 Jan 2025 08:58:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 388C720040;
	Tue, 21 Jan 2025 08:58:19 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.40.51])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Jan 2025 08:58:19 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: pv: fix arguments for
 out-of-tree-builds
In-Reply-To: <20250120164400.2261408-1-nrb@linux.ibm.com>
References: <20250120164400.2261408-1-nrb@linux.ibm.com>
Date: Tue, 21 Jan 2025 09:58:18 +0100
Message-ID: <87ldv4ee6t.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X7CU547MuJfaDutweFK0MQFpr7dQexq-
X-Proofpoint-ORIG-GUID: X7CU547MuJfaDutweFK0MQFpr7dQexq-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_04,2025-01-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501210069

On Mon, Jan 20, 2025 at 05:43 PM +0100, Nico Boehr <nrb@linux.ibm.com> wrote:
> When building out-of-tree, the parmfile was not passed to genprotimg,
> causing the selftest-setup_PV test to fail.
>
> Fix the Makefile rule s.t. parmfile is correctly passed.
>
> Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd64f44..a6cf3c144fbf 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -218,7 +218,7 @@ else
>  	GENPROTIMG_PCF := 0x000000e0
>  endif
>  
> -$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
> +$(TEST_DIR)/selftest.pv.bin: $(SRCDIR)/s390x/selftest.parmfile
>  %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
>  	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
> -- 
> 2.47.1

Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>

