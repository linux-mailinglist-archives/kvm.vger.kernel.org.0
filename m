Return-Path: <kvm+bounces-8206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA5C84C462
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 06:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC10D1C24524
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 05:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B501CD32;
	Wed,  7 Feb 2024 05:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N/GirgzU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC41CD1B;
	Wed,  7 Feb 2024 05:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707283745; cv=none; b=rYwdTYY/UKuSqWhenJxUihmtkGpLxQekQw/BX6VKnj/qHFZP+1R5ufVEfZS/Xyf7QdkgHxt+qjUikMvKwKkLJuMx6rWzsCzclXu7hRTfx0VVMpW/mgm7XvPQYY7TJYF6UpHP2cr5SpYv4npvaU3Nq+q9nzWO5v3l88nq1gBHSmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707283745; c=relaxed/simple;
	bh=i/9LvpgXGgZ77SSVigrMvMQowB8KXTdbL+Ss6ARL8YY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPIjbiL2YkFg+G74LffsZwqNQg9pZeyVQKddKypTJZHBw2xD+OY7WCfD5LML2PFkareqCc3vjywU25uRWqO0gNxyui7QJl4fVVHVSgSKsXLQqi3fWmb4VI6pXL3QZQ/5AZBZiqnmqmdZ9wiG4mYXWhPmqiALL+fdH5NO5kYLU04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N/GirgzU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4175RQFe008991;
	Wed, 7 Feb 2024 05:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=RKdLZ6KJdPreBS6zTodP4YAl+wBdS315ObfSy4389rc=;
 b=N/GirgzUnUWQXP3si2k/FugV/BKGchJeLL31q7np1CEusXm8GGaUxGGYNFuIN0PSKt1M
 MkCMN170M9VrnVQ93BAIIPtiKsrzr0K2nwZu/GxdevR03xMOUz0QJ5Q2s+xEFqBtVBTz
 Wft9xuVIr76Hz/g6c6/jscsMOF2wkS5GyqELKDrvC2mI8nQxirvCRb9EMvD+j2bx1Hn4
 TZzGMLgmFmPZAMYPoDmn878K/uT/2phI+uYmyTRxNH/bRnix47bcS7W7hUGZAYBb0SEA
 7wAKn4OudrANG2S7B4ArOFZ7JRQvkdE6fUd5LjUdH6QsjB5QYVg8xEF3253ilSZNQ1rG HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w43qn80kr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 05:28:53 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4175Sq9r014295;
	Wed, 7 Feb 2024 05:28:52 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w43qn80kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 05:28:52 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4172QCv8016137;
	Wed, 7 Feb 2024 05:28:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w22h23ac9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 05:28:51 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4175Sm9C18088640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Feb 2024 05:28:48 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1C4620040;
	Wed,  7 Feb 2024 05:28:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11D2A20043;
	Wed,  7 Feb 2024 05:28:46 +0000 (GMT)
Received: from li-a83676cc-350e-11b2-a85c-e11f86bb8d73.ibm.com (unknown [9.43.65.120])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  7 Feb 2024 05:28:45 +0000 (GMT)
Date: Wed, 7 Feb 2024 10:58:43 +0530
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Jordan Niethe <jniethe5@gmail.com>, linux-kernel@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: Re: [PATCH v3] KVM: PPC: Book3S HV: Fix L2 guest reboot failure
 due to empty 'arch_compat'
Message-ID: <t5qjoir2gvckq6vscsi4zg66grkk3px24znzfrraaq32x5wea3@ogxxeqk5vrpu>
Mail-Followup-To: Michael Ellerman <mpe@ellerman.id.au>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, 
	Jordan Niethe <jniethe5@gmail.com>, linux-kernel@vger.kernel.org, 
	Nicholas Piggin <npiggin@gmail.com>, Vaidyanathan Srinivasan <svaidy@linux.ibm.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>, 
	Vaibhav Jain <vaibhav@linux.ibm.com>
References: <20240205181833.212955-1-amachhiw@linux.ibm.com>
 <87r0hp9a4z.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0hp9a4z.fsf@mail.lhotse>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vJKbdV8S2LfECZu1weNGWppdRNnRLro8
X-Proofpoint-GUID: mZVR6pjwlinTqQk15RoF39MwZ6XhFph_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=982 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070039

Hi Michael,

Thanks for looking into the patch and your comments.

On 2024/02/06 09:09 PM, Michael Ellerman wrote:
> Hi Amit,
> 
> One comment below ...
> 
> Amit Machhiwal <amachhiw@linux.ibm.com> writes:
> > Currently, rebooting a pseries nested qemu-kvm guest (L2) results in
> > below error as L1 qemu sends PVR value 'arch_compat' == 0 via
> > ppc_set_compat ioctl. This triggers a condition failure in
> > kvmppc_set_arch_compat() resulting in an EINVAL.
> ...
> >  	
> > diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> > index 5378eb40b162..6042bdc70230 100644
> > --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> > +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> > @@ -347,8 +348,26 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
> >  			break;
> >  		}
> >  		case KVMPPC_GSID_LOGICAL_PVR:
> > -			rc = kvmppc_gse_put_u32(gsb, iden,
> > -						vcpu->arch.vcore->arch_compat);
> > +			/*
> > +			 * Though 'arch_compat == 0' would mean the default
> > +			 * compatibility, arch_compat, being a Guest Wide
> > +			 * Element, cannot be filled with a value of 0 in GSB
> > +			 * as this would result into a kernel trap.
> > +			 * Hence, when `arch_compat == 0`, arch_compat should
> > +			 * default to L1's PVR.
> > +			 *
> > +			 * Rework this when PowerVM supports a value of 0
> > +			 * for arch_compat for KVM API v2.
> > +			 */
> 
> Is there an actual plan that PowerVM will support this in future?
> 
> If so, how will a future kernel know that it's running on a version of
> PowerVM that does support arch_compat == 0?
> 
> Similarly how will we know when it's OK to drop support for this
> workaround?

I'm sending a v4 based on an off mailing list discussion.

> 
> cheers

~Amit

