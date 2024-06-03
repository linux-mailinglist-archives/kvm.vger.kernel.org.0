Return-Path: <kvm+bounces-18600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DE58D7C35
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BC281F21159
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 07:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7160B481D0;
	Mon,  3 Jun 2024 07:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="crukal6q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694F447A6C;
	Mon,  3 Jun 2024 07:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717398584; cv=none; b=PcoR3GKuXgbmpYdH/OmqV66g6mcfFBuJLULq3aWoTfWmAc2k5j+bXYflVP1HdynzcUsU5Vh4DLeWikP/T8TURLnyReUeaBK+l3AjRur3uDyGiadu/c5MX731CfFgrP7aHaacLcMUtXd2u/40vHPBHy+kJA7gn0Hq9wofV7wzzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717398584; c=relaxed/simple;
	bh=MGKhftAoxpTowHiv0oeOJrpeohaKsDS4/rlu9Zcsyko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=feHnvY6H+2WN4HunxOf6wD1jRrQHR9qNQQpiZKs0hX4B/tUHUH/5jyAnx+X9V262rrnk0pK8AqZqxKiaU5gaBDo71z0CsfUjSr7KPEz7mEFtfissKD/J5aXTxQEKZGQ95pYPnqAKjGWps8tPEPqrBYga3ogSF13rvJrC/zlzDus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=crukal6q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4536kVEl012204;
	Mon, 3 Jun 2024 07:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc : content-type : date
 : from : in-reply-to : message-id : mime-version : references : subject :
 to; s=pp1; bh=PD3QtyIGk6oeWGALWzB54J823YO78nWKEPR6OQkor9w=;
 b=crukal6q3L7fRmamiZViY4nCy7HxPQ1SzJjNWRSIKEvQgM0RavCZLtGi6Tjk27QvF1Nl
 U6i+bJ1DgoXxrjXnnrTD7RiKqxc8aUE2bphiM80b0Ktb30nIDyZY1lERrtvkdwSA1MoO
 G4WgtNXA2+Og8YJ1EIvFMc5yhlmfkq+4ORwlcNwzhbOsOsNrQNXsmPyCYKy0WdJ2dg5+
 sGRWcQxys1k8NYbRk73l+TFcgooXAIlANVg01Ukun/MvJryHlFhQ2gde0yHdmz+86qbJ
 HtEkDJqeMpl9jiR3dza3yf2iifTx5Z91PzVgcnY9pA23pIuSEfVox+qq4lLt1Zofqq6p 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yh7pkr7vt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 07:09:26 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45379QPc019761;
	Mon, 3 Jun 2024 07:09:26 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yh7pkr7vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 07:09:26 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4535DsRa000781;
	Mon, 3 Jun 2024 07:09:25 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygdytppc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 07:09:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45379LK451839364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 07:09:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C3682004F;
	Mon,  3 Jun 2024 07:09:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FD4B2004E;
	Mon,  3 Jun 2024 07:09:19 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Jun 2024 07:09:18 +0000 (GMT)
Date: Mon, 3 Jun 2024 12:39:16 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: mpe@ellerman.id.au, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, corbet@lwn.net,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 RESEND] arch/powerpc/kvm: Fix doorbell emulation by
 adding DPDES support
Message-ID: <r74chlv6bgs5csvuf4nxxtylmgartvibftp3xuztyfuynqetp5@ythddpzo6yfi>
References: <20240522084949.123148-1-gautam@linux.ibm.com>
 <D1Q54PY40E3B.22QS5DMQRA58N@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1Q54PY40E3B.22QS5DMQRA58N@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uoAnUEoMhWz5bq3pU5HjQOk-GAk36tl3
X-Proofpoint-GUID: DwVUpsKaAiVwLUFyfEy-lclbLHzjmCl8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_04,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=508 mlxscore=0 clxscore=1015 bulkscore=0 spamscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406030058

On Mon, Jun 03, 2024 at 03:42:22PM GMT, Nicholas Piggin wrote:
> On Wed May 22, 2024 at 6:49 PM AEST, Gautam Menghani wrote:
> > Doorbell emulation is broken for KVM on PowerVM guests as support for
> > DPDES was not added in the initial patch series. Due to this, a KVM on
> > PowerVM guest cannot be booted with the XICS interrupt controller as
> > doorbells are to be setup in the initial probe path when using XICS
> > (pSeries_smp_probe()). Add DPDES support in the host KVM code to fix
> > doorbell emulation.
> 
> This is broken when the KVM guest has SMT > 1? Or is it broken for SMT=1
> as well? Can you explain a bit more of what breaks if it's the latter?

Yes, doorbells are only setup when we use SMT>1 and interrupt controller
is XICS. So without this patch, L2 KOP guest with XICS IC mode and SMT>1 
does not boot. SMT 1 is fine in all cases.

> 
> > Fixes: 6ccbbc33f06a ("KVM: PPC: Add helper library for Guest State Buffers")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> > ---
> > v1 -> v1 resend:
> > 1. Add the stable tag
> >
> >  Documentation/arch/powerpc/kvm-nested.rst     |  4 +++-
> >  arch/powerpc/include/asm/guest-state-buffer.h |  3 ++-
> >  arch/powerpc/include/asm/kvm_book3s.h         |  1 +
> >  arch/powerpc/kvm/book3s_hv.c                  | 14 +++++++++++++-
> >  arch/powerpc/kvm/book3s_hv_nestedv2.c         |  7 +++++++
> >  arch/powerpc/kvm/test-guest-state-buffer.c    |  2 +-
> >  6 files changed, 27 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/arch/powerpc/kvm-nested.rst
> > index 630602a8aa00..5defd13cc6c1 100644
> > --- a/Documentation/arch/powerpc/kvm-nested.rst
> > +++ b/Documentation/arch/powerpc/kvm-nested.rst
> > @@ -546,7 +546,9 @@ table information.
> >  +--------+-------+----+--------+----------------------------------+
> >  | 0x1052 | 0x08  | RW |   T    | CTRL                             |
> >  +--------+-------+----+--------+----------------------------------+
> > -| 0x1053-|       |    |        | Reserved                         |
> > +| 0x1053 | 0x08  | RW |   T    | DPDES                            |
> > ++--------+-------+----+--------+----------------------------------+
> > +| 0x1054-|       |    |        | Reserved                         |
> >  | 0x1FFF |       |    |        |                                  |
> >  +--------+-------+----+--------+----------------------------------+
> >  | 0x2000 | 0x04  | RW |   T    | CR                               |
> > diff --git a/arch/powerpc/include/asm/guest-state-buffer.h b/arch/powerpc/include/asm/guest-state-buffer.h
> > index 808149f31576..d107abe1468f 100644
> > --- a/arch/powerpc/include/asm/guest-state-buffer.h
> > +++ b/arch/powerpc/include/asm/guest-state-buffer.h
> > @@ -81,6 +81,7 @@
> >  #define KVMPPC_GSID_HASHKEYR			0x1050
> >  #define KVMPPC_GSID_HASHPKEYR			0x1051
> >  #define KVMPPC_GSID_CTRL			0x1052
> > +#define KVMPPC_GSID_DPDES			0x1053
> >  
> >  #define KVMPPC_GSID_CR				0x2000
> >  #define KVMPPC_GSID_PIDR			0x2001
> > @@ -110,7 +111,7 @@
> >  #define KVMPPC_GSE_META_COUNT (KVMPPC_GSE_META_END - KVMPPC_GSE_META_START + 1)
> >  
> >  #define KVMPPC_GSE_DW_REGS_START KVMPPC_GSID_GPR(0)
> > -#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_CTRL
> > +#define KVMPPC_GSE_DW_REGS_END KVMPPC_GSID_DPDES
> >  #define KVMPPC_GSE_DW_REGS_COUNT \
> >  	(KVMPPC_GSE_DW_REGS_END - KVMPPC_GSE_DW_REGS_START + 1)
> >  
> > diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
> > index 3e1e2a698c9e..10618622d7ef 100644
> > --- a/arch/powerpc/include/asm/kvm_book3s.h
> > +++ b/arch/powerpc/include/asm/kvm_book3s.h
> > @@ -594,6 +594,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
> >  
> >  
> >  KVMPPC_BOOK3S_VCORE_ACCESSOR(vtb, 64, KVMPPC_GSID_VTB)
> > +KVMPPC_BOOK3S_VCORE_ACCESSOR(dpdes, 64, KVMPPC_GSID_DPDES)
> >  KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(arch_compat, 32, KVMPPC_GSID_LOGICAL_PVR)
> >  KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(lpcr, 64, KVMPPC_GSID_LPCR)
> >  KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(tb_offset, 64, KVMPPC_GSID_TB_OFFSET)
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index 35cb014a0c51..cf285e5153ba 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -4116,6 +4116,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
> >  	int trap;
> >  	long rc;
> >  
> > +	if (vcpu->arch.doorbell_request) {
> > +		vcpu->arch.doorbell_request = 0;
> > +		kvmppc_set_dpdes(vcpu, 1);
> > +	}
> 
> This probably looks okay... hmm, is the v1 KVM emulating doorbells
> correctly for SMT L2 guests? I wonder if doorbell emulation isn't
> broken there too because the L1 code looks to be passing in vc->dpdes
> but all the POWER9 emulation code uses doorbell_request.
> 

Yes launching SMT L2 on V1 API fails with a kernel Oops, I'll see if I
can fix that as well.

> > +
> >  	io = &vcpu->arch.nestedv2_io;
> >  
> >  	msr = mfmsr();
> > @@ -4278,9 +4283,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
> >  	if (kvmhv_on_pseries()) {
> >  		if (kvmhv_is_nestedv1())
> >  			trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
> > -		else
> > +		else {
> >  			trap = kvmhv_vcpu_entry_nestedv2(vcpu, time_limit, lpcr, tb);
> >  
> > +			/* Remember doorbell if it is pending  */
> > +			if (kvmppc_get_dpdes(vcpu)) {
> > +				vcpu->arch.doorbell_request = 1;
> > +				kvmppc_set_dpdes(vcpu, 0);
> > +			}
> 
> This is adding an extra get state for every entry, not good. I don't
> think it's actually needed though. I don't think the L1 cares at this
> stage what the L2 DPDES state is. So you sholud be able to drop this
> hunk.
> 
Yes ok.

> > +		}
> > +
> >  		/* H_CEDE has to be handled now, not later */
> >  		if (trap == BOOK3S_INTERRUPT_SYSCALL && !nested &&
> >  		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
> > diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> > index 8e6f5355f08b..36863fff2a99 100644
> > --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> > +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> > @@ -311,6 +311,10 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
> >  			rc = kvmppc_gse_put_u64(gsb, iden,
> >  						vcpu->arch.vcore->vtb);
> >  			break;
> > +		case KVMPPC_GSID_DPDES:
> > +			rc = kvmppc_gse_put_u64(gsb, iden,
> > +						vcpu->arch.vcore->dpdes);
> > +			break;
> >  		case KVMPPC_GSID_LPCR:
> >  			rc = kvmppc_gse_put_u64(gsb, iden,
> >  						vcpu->arch.vcore->lpcr);
> > @@ -543,6 +547,9 @@ static int gs_msg_ops_vcpu_refresh_info(struct kvmppc_gs_msg *gsm,
> >  		case KVMPPC_GSID_VTB:
> >  			vcpu->arch.vcore->vtb = kvmppc_gse_get_u64(gse);
> >  			break;
> > +		case KVMPPC_GSID_DPDES:
> > +			vcpu->arch.vcore->dpdes = kvmppc_gse_get_u64(gse);
> > +			break;
> >  		case KVMPPC_GSID_LPCR:
> >  			vcpu->arch.vcore->lpcr = kvmppc_gse_get_u64(gse);
> >  			break;
> 
> I would split all the wiring up of the DPDES GSID stuff into its own
> patch, it obviously looks fine.
> 
Noted, will do.

> > diff --git a/arch/powerpc/kvm/test-guest-state-buffer.c b/arch/powerpc/kvm/test-guest-state-buffer.c
> > index 4720b8dc8837..91ae660cfe21 100644
> > --- a/arch/powerpc/kvm/test-guest-state-buffer.c
> > +++ b/arch/powerpc/kvm/test-guest-state-buffer.c
> > @@ -151,7 +151,7 @@ static void test_gs_bitmap(struct kunit *test)
> >  		i++;
> >  	}
> >  
> > -	for (u16 iden = KVMPPC_GSID_GPR(0); iden <= KVMPPC_GSID_CTRL; iden++) {
> > +	for (u16 iden = KVMPPC_GSID_GPR(0); iden <= KVMPPC_GSID_DPDES; iden++) {
> >  		kvmppc_gsbm_set(&gsbm, iden);
> >  		kvmppc_gsbm_set(&gsbm1, iden);
> >  		KUNIT_EXPECT_TRUE(test, kvmppc_gsbm_test(&gsbm, iden));
> 
> It would be good to have a  _LAST define for such loops. It's very easy
> to miss when adding KVMPPC_GSID_DPDES that you need to grep for
> KVMPPC_GSID_CTRL. Very easy to see that you need to update _LAST.
> 
> You just need to work out a good name for it since there's a few
> "namespaces" of numbers with similar prefix. Good luck :)
> 

Well we already have a "KVMPPC_GSE_DW_REGS_END" defined, just missed to
use that. 


> Thanks,
> Nick

