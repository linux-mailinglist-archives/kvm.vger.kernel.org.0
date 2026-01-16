Return-Path: <kvm+bounces-68342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2520BD33A0F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 14835307C9C4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4C4343D80;
	Fri, 16 Jan 2026 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lWJc4Q7I"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DD91FF1B5;
	Fri, 16 Jan 2026 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768582877; cv=none; b=quxnVTH5fdsk61TZo6zV/gyZeq3aRseCKhfwuKqeMgWynPoYhY9v1/1rJ75rBW1FHe7wLhBl/5rdN+WJy26ttHoyNvY8JSfay3bJbuIVDJWj2tukopdcF8wYlJXO06r/l1HO+n6quRWrWwqdl52ekNFiy3V0/VhVHu0xW243Dt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768582877; c=relaxed/simple;
	bh=V12MOu7IOBc3vVm4pzo2DtYTJb6N2foLfx3oUeBYc3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWLlYdvPPykPa6lYSmmROXxneJzCdtxq68/7z2XFOB0CqC5ce7oTr1FvgHiq38DlumWefiy7Ip+Gb6CX8Ts5BWcp1ibBmH0D5AI8ElU37XV7OMlwYS3QbHXhdMs94myQe/1BuP2m9Htt9DfB3PbLfIFsiODMrUg5aZRefskh9QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lWJc4Q7I; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60GD9F7d016025;
	Fri, 16 Jan 2026 17:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IeSLAL
	r18IjHM7QjxvEB8l6qHAYRdf1bwKgOljUKMvs=; b=lWJc4Q7Iuk/csdkHxzHuKN
	SFjocdKC036eYDcfxZICO2hAuEaxIthiyRocrpCPJvI4MZI6voEFGJuCOTk9R2+Z
	EEcEBfEd0CEVa3b5/1Red2nUVy723cBEqVzPmhtE6pV8YrHaeccHnTvVMUJMQqmK
	tLYVnavYJAPTSIsCeidmSIhaHm5G6LGjL5oAl5q9eM6jNm3W6uruFcrRb5vm1uB7
	/eCZOSxnO9V3/AaP0LGLmfqqz02AqCFOlOLAm979xKlkm2xE+LJy6+r+2sCuAfHw
	36b/1aZEfn67xYfwy8tJUdt2KchQoM8DAYNQoHTTiZeI0QjzSE1IEQFDbV/pus7w
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9dpkxg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 17:01:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60GEDRQ9025809;
	Fri, 16 Jan 2026 17:01:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm2kkyh97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 17:01:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60GH17c627132218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 17:01:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 131F220043;
	Fri, 16 Jan 2026 17:01:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC17D20040;
	Fri, 16 Jan 2026 17:01:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.52.223.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Jan 2026 17:01:06 +0000 (GMT)
Date: Fri, 16 Jan 2026 18:01:05 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger	
 <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
Message-ID: <20260116180105.1e37f926@p-imbrenda>
In-Reply-To: <3d997b2645c80396c0f7c69f95fd8ec0d4784b20.camel@linux.ibm.com>
References: <20251217030107.1729776-1-farman@linux.ibm.com>
	<8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
	<f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
	<20260114105033.23d3c699@p-imbrenda>
	<23154a0c6b4b9e625daa2b1bbaadc349bf3a99ed.camel@linux.ibm.com>
	<3d997b2645c80396c0f7c69f95fd8ec0d4784b20.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NvzcssdJ c=1 sm=1 tr=0 ts=696a6ed8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=IMe1qbAPzq5oirr5G9MA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Ne3EledXv7JRNhkh_8oFldStme23Sr2H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEyMiBTYWx0ZWRfX/XzZdWOwjaDg
 84762B7q7lGcsWLvOjxyLAH11/hC/vir3JHUy5T8eoMcxDZQA1MztFqWu/zGhRSrSq7Skkyxu6G
 xgVUB5Rm48uVXw3vG9sf2uEHQ6+JEnlAu5VgYVUk3fCM/jf9Fet3PKKn2Y14GE98l0o/G9buNj7
 Ec1wh7RQGpq5txZc4sxzOdOk96wrz9FV4ZcX+24BpWJg377tsoGHTLTOu78eha62PBa8tV0V/49
 oeS9WASWQhKOnzXqCGNueVLJorEDeAN8k8edoRZDkM5uFGebjZH8cS71176FsVTD2gPW3V522By
 bHzdZD5cGJcnwXKcZ7OmSygXI2Ci0lNVQfONPy464766k3PRoPmEvxRKVgtAKbJ1ITbBEwEZARi
 sKbNtYgw9WId2woPFNHurUPTqx2xeRF2jlRMxJFYNnFSla4lJxS/iJsBX+zQk1AKz8MEYISUQt7
 rzfZ+Gtjgt0qTav4tHQ==
X-Proofpoint-ORIG-GUID: Ne3EledXv7JRNhkh_8oFldStme23Sr2H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601160122

On Fri, 16 Jan 2026 10:45:22 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On Thu, 2026-01-15 at 16:17 -0500, Eric Farman wrote:
> > On Wed, 2026-01-14 at 10:50 +0100, Claudio Imbrenda wrote:  
> > > On Mon, 05 Jan 2026 10:46:53 -0500
> > > Eric Farman <farman@linux.ibm.com> wrote:
> > >   
> > > > On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:  
> > > > > On 12/17/25 04:01, Eric Farman wrote:    
> > > > > > SIE may exit because of pending host work, such as handling an interrupt,
> > > > > > in which case VSIE rewinds the guest PSW such that it is transparently
> > > > > > resumed (see Fixes tag). There is still one scenario where those conditions  
> > > 
> > > can you add a few words to (very briefly) explain what the scenario is?  
> > 
> > Maybe if this paragraph were rewritten this way, instead?
> > 
> > --8<--
> > SIE may exit because of pending host work, such as handling an interrupt,
> > in which case VSIE rewinds the guest PSW such that it is transparently
> > resumed (see Fixes tag). Unlike those other places that return rc=0, this
> > return leaves the guest PSW in place, requiring the guest to handle an
> > intercept that was meant to be serviced by the host. This showed up when
> > testing heavy I/O workloads, when multiple vcpus attempted to dispatch the
> > same SIE block and incurred failures inserting them into the radix tree.  
> > -->8--  
> 
> Spoke to Claudio offline, and he suggested the following edit to the above:
> 
> --8<--
> SIE may exit because of pending host work, such as handling an interrupt,
> in which case VSIE rewinds the guest PSW such that it is transparently
> resumed (see Fixes tag). Unlike those other places that return rc=0, this
> return leaves the guest PSW in place, requiring the guest to handle a
> spurious intercept. This showed up when testing heavy I/O workloads,
> when multiple vcpus attempted to dispatch the same SIE block and incurred
> failures inserting them into the radix tree.
> -->8--  

with the above text:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


> 
> > 
> > @Janosch, if that ends up being okay, can you update the patch or do you want me to send a v2?
> >   
> > >   
> > > > > > are not present, but that the VSIE processor returns with effectively rc=0,
> > > > > > resulting in additional (and unnecessary) guest work to be performed.
> > > > > > 
> > > > > > For this case, rewind the guest PSW as we do in the other non-error exits.
> > > > > > 
> > > > > > Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on host intercepts")
> > > > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>    
> > > > > 
> > > > > This is purely cosmetic to have all instances look the same, right?    
> > > > 
> > > > Nope, I can take this path with particularly high I/O loads on the system, which ends up
> > > > (incorrectly) sending the intercept to the guest.  
> > > 
> > > this is a good candidate for the explanation I mentioned above :)
> > > 
> > > 
> > > (the patch itself looks fine)  


