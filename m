Return-Path: <kvm+bounces-34217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 083029F955F
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FEAE1897415
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 15:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EB0E218EB2;
	Fri, 20 Dec 2024 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pSEcy4s7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780D8215713;
	Fri, 20 Dec 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734708163; cv=none; b=nvugBhtSJ2VFlPkr5YCBkNMlz75v4gbIS4kugboV4CeZRsLGQ82nFujpxsvC48h/rw26GtoFr2zKfHgkuRIS+2Orq5Cqyx/VRB86I6W0wfRzjrRx89yYS8+yH4a2PmC4KNDpPPcp6FAB5DJoah0SV/SjrwJ3GkT3N5koFPjZQIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734708163; c=relaxed/simple;
	bh=/W7zQRHLWYkrdCwj39EIf+V3biaa2rEpIK1TYYmPaHU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=LHrk4x8ZunXTP+QA7f+acPZ/mclsNJTmo+zW6TjDzi+Fewoa0VdK/Ratc0EJvQnNwYkq2A5kJTqJrtS8nZweoRNrXomySaYt4vhRkR+B4l33Py5BYZ6/7T7E915kHCkHVrroODs+s8iPZZlh/Ey5sfqvbWMgGV+RdEHMWNnuPsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pSEcy4s7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKE6Pnw022371;
	Fri, 20 Dec 2024 15:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Op2les
	FEA7RR++75w2AtqCnoplzID8i5/GEw9L7IBKQ=; b=pSEcy4s7jf+apZNP00A3oS
	wWHVKW+6zCu5e+eit3qLTG+Ietg0aOZLJH3P+TuoH9TK0lYckKGCY3/9tAoXaD1M
	21V+IX64BdK+OCYlBzvcXtS7G0x6hfEbxTVOi7iJkkz6ECoAEV+fITfkkHPAmbqy
	jMK8/k4MJcIioS4PcSJV068FOvVTZv7ujsySy06bMr1Q/2GIovJau32k00nD7R//
	uAlN78XsKpFQ5GbkzffVyELDsWMKE3OekMM0ZI+VtKv49hOgayKcu2cpShstX7uZ
	RRqSV68l6EFaJZSGQeUhl7ELxpxm1yfxVuoFH8B6LGKn0QkXGnwyhHOaCr77Pzrw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43na258d1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 15:22:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKE3j1Y005544;
	Fri, 20 Dec 2024 15:22:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43hnbnjqdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 15:22:37 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BKFMVpH54460906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Dec 2024 15:22:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A00E2004B;
	Fri, 20 Dec 2024 15:22:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4156420043;
	Fri, 20 Dec 2024 15:22:31 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.46.101])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Dec 2024 15:22:31 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Dec 2024 16:22:31 +0100
Message-Id: <D6GMPV211UPF.CC1OSNJYEJ6T@linux.ibm.com>
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Cc: <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>, <thuth@redhat.com>,
        <david@redhat.com>, <schlameuss@linux.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: pv: Add test for large
 host pages backing
X-Mailer: aerc 0.18.2
References: <20241218135138.51348-1-imbrenda@linux.ibm.com>
 <20241218135138.51348-4-imbrenda@linux.ibm.com>
In-Reply-To: <20241218135138.51348-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8N59N5kfHqgCkx3AhnWdqAdPA7tLI_sw
X-Proofpoint-ORIG-GUID: 8N59N5kfHqgCkx3AhnWdqAdPA7tLI_sw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 phishscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412200123

On Wed Dec 18, 2024 at 2:51 PM CET, Claudio Imbrenda wrote:
[...]
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 611dcd3f..7527be48 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
[...]
> +static inline int uv_merge(uint64_t handle, unsigned long gaddr)
> +{
> +	struct uv_cb_cts uvcb =3D {
> +		.header.cmd =3D UVC_CMD_VERIFY_LARGE_FRAME,
> +		.header.len =3D sizeof(uvcb),
> +		.guest_handle =3D handle,
> +		.gaddr =3D gaddr,
> +	};
> +
> +	return uv_call(0, (uint64_t)&uvcb);
> +}

This function seems unused and uvc_merge() below looks very similar.

[...]

> diff --git a/s390x/pv-edat1.c b/s390x/pv-edat1.c
> new file mode 100644
> index 00000000..3f96c716
> --- /dev/null
> +++ b/s390x/pv-edat1.c
[...]
> +#define FIRST		42
> +#define SECOND		23

It was not obvious to me what these mean. It would be easier for me to
understand if they had some name like GUEST_READ_DONE_GET_PARAM and
SHOULD_EXIT_LOOP (or so) and share the define with the guest or at least ha=
ve
defines with the same name in the guest (see also below).

[...]
> +static inline void assert_diag500_val(struct vm *vm, uint64_t val)
> +{
> +	assert(pv_icptdata_check_diag(vm, 0x500));
> +	assert(vm->save_area.guest.grs[2] =3D=3D val);
> +}

I would appreciate it if you could base on Ninas STFLE series and use
snippet_check_force_exit_value() here. See
https://lore.kernel.org/kvm/20240620141700.4124157-6-nsg@linux.ibm.com/
See also below.

[...]
> +static void test_run(void)
> +{
> +	int init1m, import1m, merge, run1m;
> +
> +	report_prefix_push("test run");
> +
> +	for (init1m =3D 0; init1m < 1; init1m++) {

Are you sure this does what you want it to do?

[...]
> +static void test_merge(void)
> +{
> +	uint64_t tmp, mem;
> +	int cc;
> +
> +	report_prefix_push("merge");
> +	init_snippet(&vm);
> +
> +	mem =3D guest_start(&vm);
> +
> +	map_identity_all(&vm, false);
> +	install_page(root, mem + 0x101000, (void *)(mem + 0x102000));
> +	install_page(root, mem + 0x102000, (void *)(mem + 0x101000));
> +	install_page(root, mem + 0x205000, (void *)(mem + 0x305000));

(see below)

[...]
> +	/* Not all pages are aligned correctly */
> +	report(uvc_merge(&vm, mem + 0x100000) =3D=3D 0x104, "Pages not consecut=
ive");
> +	report(uvc_merge(&vm, mem + 0x200000) =3D=3D 0x104, "Pages not in the s=
ame 1M frame");

It would be easier for me to understand if the regions were named, e.g. wit=
h a
variable for each region, for example:

uint64_t non_consecutive =3D mem + 0x100000

and then above

install_page(root, mem + 0x101000, (void *)(non_consecutive + 0x2000));
install_page(root, mem + 0x102000, (void *)(non_consecutive + 0x1000));

[...]
> diff --git a/s390x/snippets/c/pv-memhog.c b/s390x/snippets/c/pv-memhog.c
> new file mode 100644
> index 00000000..43f0c2b1
> --- /dev/null
> +++ b/s390x/snippets/c/pv-memhog.c
> @@ -0,0 +1,59 @@
[...]
> +int main(void)
> +{
> +	uint64_t param, addr, i, n;
> +
> +	READ_ONCE(*MIDPAGE_PTR(SZ_1M + 42 * PAGE_SIZE));
> +	param =3D get_value(42);

(see below)

> +	n =3D (param >> 32) & 0x1fffffff;
> +	n =3D n ? n : N_PAGES;
> +	param &=3D 0x7fffffff;
> +
> +	while (true) {
> +		for (i =3D 0; i < n; i++) {
> +			addr =3D ((param ? i * param : i * i * i) * PAGE_SIZE) & MASK_2G;
> +			WRITE_ONCE(*MIDPAGE_PTR(addr), addr);
> +		}
> +
> +		i =3D get_value(23);
> +		if (i !=3D 42)

I would like some defines for 23 and 42 and possibly share them with the ho=
st.

