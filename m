Return-Path: <kvm+bounces-6295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C2C782E4DF
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 01:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B260B23582
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 00:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D79D2033B;
	Tue, 16 Jan 2024 00:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ULBb8hGM";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Zfh2TBE6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A920303
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 00:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40FNV9vN021967;
	Mon, 15 Jan 2024 16:14:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=proofpoint20171006; bh=0RSBexo9WU7Ml4LufFMaOVTxUt/pW7jxK2LP3v
	Vfhok=; b=ULBb8hGMtBniNnqBOCoqB6OLCUOkjr6YiuFE2Kocw0T5MQqyJgy+wo
	mRI6lzFrSWqY5XbXhoi07/iqVGybSbinZbUGngGtzfI2xv1TUEL/mF4KE1v36dGi
	0et0/NZpTkD5tU7XPJIBkf+UkYOly/j0QiEEE2l7mu2GQHO6KhDGnzjr6Hx0uGug
	Qsnwcet84jW0lhj8N9huU+t3C2kORrS733E4FzOfWoJHWZMvBpMpYf42Vo+iKb1h
	Q6lyd/TeWAzqldXdvtqWD9E71OaBFmntTKWMaP9X6pN6a+n/4y9FemyVCnSFqLjU
	p20npI/ZKbgVBfkKEBoYZTAwKshRw62A==
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3vktxyushj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jan 2024 16:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCHn22CCSr22ljZ8i5LDwKvz5JDOFgWjzwivQkTFAVS00MVuaTMm1ja4qddUe7kqtt/dSuCc/81N9q/5Qz7v5VfxRt5+L4iG/yZKHKBqeljK+CuVQ8reGXtru4iT+y6NTgCwOHnSrJEB6RF4Ufis0qOW9jg/7D+Sc3I85BcWBfuOFK8LEuSBmVyH8OcZ/z2IeC9ngd0k0Z0KDT2CeqsYGT+C7GzYpHQvDNXEpF0CbVk+9nsEQabNKI1bp/Yv/7atgKoCeLLZZCETJDaL3GDMYmWiuQMNB52YXkykNP/GLFi0l7ql6D9GKIAx9nBIYQxudlJrvYKVjl04T/CkVaX8CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RSBexo9WU7Ml4LufFMaOVTxUt/pW7jxK2LP3vVfhok=;
 b=J+cyIq5iRCPneUOOcoN9+Q4yXTi6ALixO2dPSGZtNtR1avCRflThn/0IMPcAag3zb3OMQ2PtsRAd3XYtSQtNhbTxnzfcZZYrWo5p4J5ilBp9t0RlIupI5O32NiH5b7qyWiJwtwvBoC5mpbnNwyo+AL6bDBCL7WqBELFDNma6cgArdoEKXzecPEIBleuPyz/S54BIfpDhLzd7ncn/GSKG/qlIVnuPgVOPtOK4fOLuZsTUVXO5/+RvoV5L0qoVbbdGKt8mjIMm3b4RYtvtgZlSvp3UX5gWLUxjJPymPoq8Lqtfq/kyMbmXsi9RU0AF/WLZGI2+pKFstpzN9fu17qpGeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RSBexo9WU7Ml4LufFMaOVTxUt/pW7jxK2LP3vVfhok=;
 b=Zfh2TBE6xWZ3PlBhVGYogNysplS1khX8DRpornYwlNsoroDCU395rUaoUDnW5cino327i/2A2qsmb/MleV2Z2csQPiwcvBnHWqCkKVplAro7cLeGHXBrt4/uLe9ZoSxZIlxl+wULhz1Rns60jjC4T1d5YLYLH7LYiutpzA7+1eFmp0cHR57ppdSMe8mMv83Wk5lKPEy+Xxs4JvJNznvyAYungwfgEAWWZ4W+i53JV9faqrOxlzp1D+EZeiM/vpgMm1tqNgO2z8iqcC15+u9NR2H5rBA4YksldlEoLf4x03mbVQKvZhaqwhesI+OfeUcTX3Ox7UmYBWtR4pSJda0ALA==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by SJ0PR02MB7709.namprd02.prod.outlook.com (2603:10b6:a03:325::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.28; Tue, 16 Jan
 2024 00:13:58 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::76b9:134e:604f:7d37]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::76b9:134e:604f:7d37%4]) with mapi id 15.20.7181.015; Tue, 16 Jan 2024
 00:13:58 +0000
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Maxim Levitsky
	<mlevitsk@redhat.com>,
        =?iso-8859-1?Q?Philippe_Mathieu-Daud=E9?=
	<philmd@linaro.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Thread-Topic: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Thread-Index: 
 AQHaB89aXI5Xqc3T6k+NVdRuk3VgqLBbkLwAgAAA7YCAADJMAIAI/UwAgADHy4CACiilgIBsYG4A
Date: Tue, 16 Jan 2024 00:13:58 +0000
Message-ID: <585D19C7-80BD-4599-ABBD-A0FE25F0ACB9@nutanix.com>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
 <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
 <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org> <87wmv93gv5.fsf@redhat.com>
 <D3D6327A-CFF0-43F2-BA39-B48EE2A53041@nutanix.com>
 <87edh9h8nk.fsf@redhat.com>
 <7A7A55C5-6151-453A-852C-96CD10098EE6@nutanix.com>
In-Reply-To: <7A7A55C5-6151-453A-852C-96CD10098EE6@nutanix.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR02MB8041:EE_|SJ0PR02MB7709:EE_
x-ms-office365-filtering-correlation-id: 9ec8d5bc-0a68-423a-8d1b-08dc162808c9
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 /7NR0IMMtAhbxUMwMUcFVI0WNV6u72KEedTxwiC90+rzAlTDUE7nD5MD8Da3fjUiKbHadNOpsRkfw3gVogySrEtQ4ezkXki10OvmgKXclp/Hoo+dxNu/1PeIr5Uh4Bvagf4HXgLDqgxjaEaamNTrgo1k0yM6lfz0nBPK/Yqwm54x62+IZVshKQ94QofNAYpagVjKCjJJBWR63Px3v2lLo4OKwz/GZ8uIeKlUFkIyxbgfGt2bRJtz3fv44VcmIBvaf11Do2aNxSybm83bbBGWJfxDYYLsmGvK2y1wh674WoAhcfWVDzmxx9yMxEg5MMGPPQp0SiCPNWRZ8hAlgHhK66DDnCza1QYieFG54CAdVdU7nTeKKVlhJRMXc8jFNZRusR8rokL10nSvY3hM0IkHICIXrs5ivSFL8QeAJ1/hRlCHi6A+DJCCg5ZRyTOHNFiiorFaNFEUGz7xPZWlx+dAaHbvFnKARyZHRNxhvTTSe8KIN6jzhaZAMKCWv9jYlHZXP2rG5LTEyQrE0B3leQrSLSGDaQz8Wvf+oaIehwGyo1qLRuifwljrv8xUPESqAooya0mTQOdKrwkmmVagPRvhW1wdbB5kUO5NvK1MWbt29bW8moIVngNP+4i2vWV0iGs3iqfXhOy7IYeqaCAThVOy7g==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(5660300002)(6506007)(6512007)(2906002)(76116006)(54906003)(66446008)(66556008)(66946007)(64756008)(53546011)(122000001)(8676002)(8936002)(4326008)(316002)(6916009)(38100700002)(44832011)(71200400001)(91956017)(6486002)(478600001)(66476007)(38070700009)(33656002)(41300700001)(26005)(2616005)(36756003)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?OcnnYb2dVmY32+46hF2i/YshqVcMArjWWGDnVTfO4aUG4MD76WIN714ojr?=
 =?iso-8859-1?Q?TFWiSS8a8djfwutYmvhVLETo5W4Lq4cordwRcvr87fcxXxe+TPHzNKAdv9?=
 =?iso-8859-1?Q?6wNFtwvA/j+eS6k5ku0SP1unX7eqEl9RHLmRXB9I88ibnP0dNm7cnrJSYr?=
 =?iso-8859-1?Q?tiDviAvqCd5FagSkPdCafijz8IeNYENepdvKMKYKBih3adk21ysNnd8bBY?=
 =?iso-8859-1?Q?wJ60qygOEKH6oNfNVCnrFJZ9pXPNl879bY/X18W1itp0L17y2rCH4qGJT2?=
 =?iso-8859-1?Q?dREXZwWzm/TcwZYmCumWQPVbDWSjCP7DVww5+cnLR5eJh57wC0iPsMZ5Km?=
 =?iso-8859-1?Q?K83x2j0W5yiaqUbWUwLqcHeHIGn0ibrBmXxhzfNQun9H2+P1UmKc7PkP4P?=
 =?iso-8859-1?Q?TJxj/R/xRBcGD0U7e/nwAYWvrtbfA/pzmeShcEsLWAAsoL51E+hZNsgKud?=
 =?iso-8859-1?Q?7V9DI7CrK8d5QpnnYZRrFsEEz5kOJU/nKSziTmGqSPD5JZ2xaoAAhCgeJv?=
 =?iso-8859-1?Q?MfWAT6SPL+4krHrV/4tJ1U02ww/CAANNzu72LHUIUTSV7uKUCsX79VXTLe?=
 =?iso-8859-1?Q?SQFTWY0j/9EpDVEKzOz1fTqvCDbCRp1AZB+hXdVg2b7nc0BhvzC0dj1Yl8?=
 =?iso-8859-1?Q?IpieKkjg5zFVKh1zvL889886uPUbiVpeY+zsv+IhXKscYT9eNJKYM/02eV?=
 =?iso-8859-1?Q?/kzaNiwHgtjDwTjLlJju5kl9Wi5le8JOcsgttFdbEbd0DAgAl69fioGGY7?=
 =?iso-8859-1?Q?afw7wo1rIcKMwpTLlntwKhv23Ye3eEaR1CsvezVVk3Jg7dXbAlhYIIHewR?=
 =?iso-8859-1?Q?5XdiGhFMsK3wwm0PQi6pkY3FPJ/ydOlXl/Oqs3l3nA+shh8LqvdQEdW4J/?=
 =?iso-8859-1?Q?PY7PVhtRaTJ46V1ceu6o4TlEXLl5O/Ue/dzv+SfyioUPCqeHuRCdN0OW1H?=
 =?iso-8859-1?Q?2VcYkvjFbs7p1Yl5Xq/RnOBrSVM3xIRLZ0JB+XGlnu0buk+W7YTlfM1TOi?=
 =?iso-8859-1?Q?8owBrLWsAtrfXvqhep/pqVs7QwbEYvhN9IYp9ZTH3zB/B13p1SyCfF/uU8?=
 =?iso-8859-1?Q?92CiJFs57kDPvsjOHIB6sCn+KfdghFZ0OiXIdIg3layMbkT9NLS2iQXUkp?=
 =?iso-8859-1?Q?zz0C0KT9gG+uYAU/ThNSfMV9+YtNU9nFA6UbqDdPvLd5XBog/EfB1ExuIh?=
 =?iso-8859-1?Q?V6x+DOyTBDdXVJeHUWbIdl72lTopvU+fAy9cB9+Wyf4FrnfgjorgTElsIl?=
 =?iso-8859-1?Q?aFb1QM5UvKBk+cVUlNHX5BIJezyNhRIB2pg9ajtnAs3/1If02J5DL9rjhW?=
 =?iso-8859-1?Q?xK+UfpiaFhTWp2R0UJcPF93Y2V31Xix9Suf8V/PMRssdsgEBg1czH9lRcN?=
 =?iso-8859-1?Q?xDEwJCzCcoBQwrjsRkGcHsWawXUw6uQqQ0/WgdkERyermmKRWR/d7oxYQ5?=
 =?iso-8859-1?Q?MfaHTCXG44yuouIWL3CdtBt5sK0OFy2jJqF1s943oD04vcOcBuOlVCf9UI?=
 =?iso-8859-1?Q?On57bCospMtkOj7DOgV/SxMPc69h39Fk28dgVpfjFaNoesklHjwCp4rapb?=
 =?iso-8859-1?Q?g3zRbEPeT/ob0mzr76oWOCblg5yjjHp+Vn2xG6ry3pIqePK2jcXvmCp1vX?=
 =?iso-8859-1?Q?3xbprRA+rmmAHhvwR0b3ctH9uIy9xwLoJ7CNTDcjnRO6SrNjbftzZbTA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <CFF27EA819A8944BA6EF59B50B016352@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec8d5bc-0a68-423a-8d1b-08dc162808c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2024 00:13:58.1112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3VuhVkZSOfLAhvtnYwQBTmd7A7Lv+zHNs+wMkzqjkzr75BtAYLqDCDq79IT4zgC+Agn89tLessiPYK3T6RC/Edf4g+ejn+EA4+e9d8G58Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7709
X-Proofpoint-ORIG-GUID: NIqFcWtmVKIlpRR99C8-zG9qppxfytF9
X-Proofpoint-GUID: NIqFcWtmVKIlpRR99C8-zG9qppxfytF9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_27,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

Ping.

> On Nov 8, 2023, at 10:12, Eiichi Tsukata <eiichi.tsukata@nutanix.com> wro=
te:
>=20
> Hi all, appreciate any comments or feedbacks on the patch.
>=20
> Thanks,
> Eiichi
>=20
>> On Nov 1, 2023, at 23:04, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>=20
>> Eiichi Tsukata <eiichi.tsukata@nutanix.com> writes:
>>=20
>>> FYI: The EINVAL in vmx_set_nested_state() is caused by the following co=
ndition:
>>> * vcpu->arch.hflags =3D=3D 0
>>> * kvm_state->hdr.vmx.smm.flags =3D=3D KVM_STATE_NESTED_SMM_VMXON
>>=20
>> This is a weird state indeed,
>>=20
>> 'vcpu->arch.hflags =3D=3D 0' means we're not in SMM and not in guest mod=
e
>> but kvm_state->hdr.vmx.smm.flags =3D=3D KVM_STATE_NESTED_SMM_VMXON is a
>> reflection of vmx->nested.smm.vmxon (see
>> vmx_get_nested_state()). vmx->nested.smm.vmxon gets set (conditioally)
>> in vmx_enter_smm() and gets cleared in vmx_leave_smm() which means the
>> vCPU must be in SMM to have it set.
>>=20
>> In case the vCPU is in SMM upon migration, HF_SMM_MASK must be set from
>> kvm_vcpu_ioctl_x86_set_vcpu_events() -> kvm_smm_changed() but QEMU's
>> kvm_put_vcpu_events() calls kvm_put_nested_state() _before_
>> kvm_put_vcpu_events(). This can explain "vcpu->arch.hflags =3D=3D 0".
>>=20
>> Paolo, Max, any idea how this is supposed to work?
>>=20
>> --=20
>> Vitaly
>>=20
>=20


