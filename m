Return-Path: <kvm+bounces-34221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3549F95EC
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 906C21888231
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 15:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450C021A450;
	Fri, 20 Dec 2024 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pxOVAlLb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F262218AB7;
	Fri, 20 Dec 2024 15:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734709958; cv=none; b=HRObKWmg4afK0aEc3l8NzZlrKUescwU3snSzJhQuihdTO9CjvqbnNjY0ulT9OcGhr8NljlG2LA8tVCjbd49C1c317a8W2WmzAaSxKwYuTHO8qnnajhbkPMIPKw7udgK8uz2BVU8qji3EgeNs2+GXLZrBLFeIMg7BscDkTfwzkmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734709958; c=relaxed/simple;
	bh=45SLY3RrsB4iphzqS+3+JN+hYpUv5TbGF6vzun+waEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B291qrdniSJOnN64kNwrbJOb9W7vzHnBgaYWNmZF0+RedrlL/KeuZuySkk9ciiGqKz/mediuWm32nz2z+7IpLWAxp53yELfqjFd7Iudaz+BzIQ5ptmRmcpIn+aaup/SuYbQikSWCE6XaM7eAfv3F3TGm/5FN4bVu+WDNzZtNH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pxOVAlLb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKCadAt001763;
	Fri, 20 Dec 2024 15:52:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+zO2JD
	+C9mFmUvlzaTfMfmOpJ+XQuA0mvhwr/9KBiS0=; b=pxOVAlLbBDr/RUHdUq5z5v
	gZu2BxDvTMaZ1r7kj5ozkGL3A+xVtZlIRWLwK213GNcM8nIGgNR0MZNCvK6Oja2Q
	/T9gIW+XH8c3rUuwMGKy/Dsqbb9qA0slXbRaH98fD3sS1j0rMs1OmTzhsNSk/ohY
	2NlPzvpu0O2o81IuCzE4zVQK3XAKgqo3HT8mVzAopl3jZWvkwPNDZqBmmwMVQNcj
	vD65pA5dBUIbwEAYW3uAGUyNRgEmEpMeL/uCg7yUWgb0Pougyxd/825ACzq+VSqo
	rukOsk1h20GyuAGOMoTNdieiUHK5BD+IEIcdIGgTGy943nnDBNkvSl9aD9dwiTZw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43mwmhkqbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 15:52:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKDqtiW005491;
	Fri, 20 Dec 2024 15:52:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43hnbnjt58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 15:52:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BKFqQqr14876978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Dec 2024 15:52:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4CDD2004B;
	Fri, 20 Dec 2024 15:52:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9701520043;
	Fri, 20 Dec 2024 15:52:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Dec 2024 15:52:26 +0000 (GMT)
Date: Fri, 20 Dec 2024 16:52:24 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Nico Boehr" <nrb@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <thuth@redhat.com>, <david@redhat.com>, <schlameuss@linux.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: pv: Add test for large
 host pages backing
Message-ID: <20241220165224.3307fbf4@p-imbrenda>
In-Reply-To: <D6GMPV211UPF.CC1OSNJYEJ6T@linux.ibm.com>
References: <20241218135138.51348-1-imbrenda@linux.ibm.com>
	<20241218135138.51348-4-imbrenda@linux.ibm.com>
	<D6GMPV211UPF.CC1OSNJYEJ6T@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yGgVZ3y5UzW7zB-Z9nzAMIBvrNY2LXi8
X-Proofpoint-GUID: yGgVZ3y5UzW7zB-Z9nzAMIBvrNY2LXi8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412200125

On Fri, 20 Dec 2024 16:22:31 +0100
"Nico Boehr" <nrb@linux.ibm.com> wrote:

> On Wed Dec 18, 2024 at 2:51 PM CET, Claudio Imbrenda wrote:
> [...]
> > diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> > index 611dcd3f..7527be48 100644
> > --- a/lib/s390x/asm/uv.h
> > +++ b/lib/s390x/asm/uv.h  
> [...]
> > +static inline int uv_merge(uint64_t handle, unsigned long gaddr)
> > +{
> > +	struct uv_cb_cts uvcb = {
> > +		.header.cmd = UVC_CMD_VERIFY_LARGE_FRAME,
> > +		.header.len = sizeof(uvcb),
> > +		.guest_handle = handle,
> > +		.gaddr = gaddr,
> > +	};
> > +
> > +	return uv_call(0, (uint64_t)&uvcb);
> > +}  
> 
> This function seems unused and uvc_merge() below looks very similar.

it's a leftover, will remove

> 
> [...]
> 
> > diff --git a/s390x/pv-edat1.c b/s390x/pv-edat1.c
> > new file mode 100644
> > index 00000000..3f96c716
> > --- /dev/null
> > +++ b/s390x/pv-edat1.c  
> [...]
> > +#define FIRST		42
> > +#define SECOND		23  
> 
> It was not obvious to me what these mean. It would be easier for me to
> understand if they had some name like GUEST_READ_DONE_GET_PARAM and
> SHOULD_EXIT_LOOP (or so) and share the define with the guest or at least have
> defines with the same name in the guest (see also below).

will do

> 
> [...]
> > +static inline void assert_diag500_val(struct vm *vm, uint64_t val)
> > +{
> > +	assert(pv_icptdata_check_diag(vm, 0x500));
> > +	assert(vm->save_area.guest.grs[2] == val);
> > +}  
> 
> I would appreciate it if you could base on Ninas STFLE series and use
> snippet_check_force_exit_value() here. See
> https://lore.kernel.org/kvm/20240620141700.4124157-6-nsg@linux.ibm.com/
> See also below.
> 
> [...]
> > +static void test_run(void)
> > +{
> > +	int init1m, import1m, merge, run1m;
> > +
> > +	report_prefix_push("test run");
> > +
> > +	for (init1m = 0; init1m < 1; init1m++) {  
> 
> Are you sure this does what you want it to do?

I'm quite sure it does __not__ do what I want it to :D
I'll fix it

> 
> [...]
> > +static void test_merge(void)
> > +{
> > +	uint64_t tmp, mem;
> > +	int cc;
> > +
> > +	report_prefix_push("merge");
> > +	init_snippet(&vm);
> > +
> > +	mem = guest_start(&vm);
> > +
> > +	map_identity_all(&vm, false);
> > +	install_page(root, mem + 0x101000, (void *)(mem + 0x102000));
> > +	install_page(root, mem + 0x102000, (void *)(mem + 0x101000));
> > +	install_page(root, mem + 0x205000, (void *)(mem + 0x305000));  
> 
> (see below)
> 
> [...]
> > +	/* Not all pages are aligned correctly */
> > +	report(uvc_merge(&vm, mem + 0x100000) == 0x104, "Pages not consecutive");
> > +	report(uvc_merge(&vm, mem + 0x200000) == 0x104, "Pages not in the same 1M frame");  
> 
> It would be easier for me to understand if the regions were named, e.g. with a
> variable for each region, for example:
> 
> uint64_t non_consecutive = mem + 0x100000
> 
> and then above
> 
> install_page(root, mem + 0x101000, (void *)(non_consecutive + 0x2000));
> install_page(root, mem + 0x102000, (void *)(non_consecutive + 0x1000));

hmmm ok I'll do that

> 
> [...]
> > diff --git a/s390x/snippets/c/pv-memhog.c b/s390x/snippets/c/pv-memhog.c
> > new file mode 100644
> > index 00000000..43f0c2b1
> > --- /dev/null
> > +++ b/s390x/snippets/c/pv-memhog.c
> > @@ -0,0 +1,59 @@  
> [...]
> > +int main(void)
> > +{
> > +	uint64_t param, addr, i, n;
> > +
> > +	READ_ONCE(*MIDPAGE_PTR(SZ_1M + 42 * PAGE_SIZE));
> > +	param = get_value(42);  
> 
> (see below)
> 
> > +	n = (param >> 32) & 0x1fffffff;
> > +	n = n ? n : N_PAGES;
> > +	param &= 0x7fffffff;
> > +
> > +	while (true) {
> > +		for (i = 0; i < n; i++) {
> > +			addr = ((param ? i * param : i * i * i) * PAGE_SIZE) & MASK_2G;
> > +			WRITE_ONCE(*MIDPAGE_PTR(addr), addr);
> > +		}
> > +
> > +		i = get_value(23);
> > +		if (i != 42)  
> 
> I would like some defines for 23 and 42 and possibly share them with the host.

not sure what's the easiest way to share with the host, but I can just
copy the defines

