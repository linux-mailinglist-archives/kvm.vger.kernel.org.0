Return-Path: <kvm+bounces-8479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3046484FCCC
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A76DB269B2
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2805B83CA6;
	Fri,  9 Feb 2024 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="H02Exlcj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13DF53398;
	Fri,  9 Feb 2024 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707506822; cv=fail; b=Eqte+eDsc6x7EuAYXqRaGnTXGuFKLFNORbCuOdwQLHdGTqzsHSkRkEl6BysU2Z+LCMmkBrdIg/UsXxo+YhPNgponFZFGKeRZmq+FZZJa87bHPpkFfplPAVjmmtUuScO0/OBq7jQG32i0Ft/QiKacthzmy/p8203GsrUAGVpKLWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707506822; c=relaxed/simple;
	bh=vldEp5cPkqnDwW7G40ROQ0eKtPmMp+mCdbLx2ySRGkg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EfLd1gbiYEQvLyZ4cMe5a2wHefSivLeYnrA6nU0W0PnY6VmBT9xceuNwiFZJKvKZCubQI7trF/IjHUiz2vGMsiwLp9JTWdlcGlBSgmaaI3SI3wVNYT3BzTpU3uRhZx+4wQl/jprsZTEi9ZNnebCwWDhjqtIkLrOTfhmi0DQhMxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=H02Exlcj; arc=fail smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 419F8tSt011551;
	Fri, 9 Feb 2024 19:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=vldEp5cPkqnDwW7G40ROQ0eKtPmMp+mCdbLx2ySRGkg=; b=H0
	2ExlcjCe9X31lwev++hmR8hBGIhgbfXJew4UFEi9C7FhngLpY9uCjYrLNVC4UFSa
	fUmeaBVEkPpTHx4JRY/MpbppTA/91//VUx8KKkgCMuAppyBhNWCB6GiZe566M6eR
	dXJDLdDLlyfFOfa6/br4Ci+2xyL9emvv2lVHVpwnF2BNMQtw9u4cVyDml/TP0SCQ
	pqI7RokNmfG2Lgl2RdAyF5aZueSl0NHDuLy691QErvyd9Ed7g4ix0ob3+ziAahBY
	DFsGKXqLmOTdalFyvMVJGAm+n2qaKNNFAsmC0rCycvA39Bc1aJYrsJK7EKhF6Fkp
	srJv3wRfkHMp0u/v49GA==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3w5ef1smya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Feb 2024 19:26:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOTMNSoHprYbQ1M3BzpOBdeyWhUdkYODYWjvZWQ7YtiX6vyduJc+bf+tkAamK/ysCUzjzLcb7npzlLr1g9pgyxsbaeYL6cbH13W5jyKhlPhMvnMhgsLM509kGex35MurMkDYMTMufHr7i7f81MZsl8NrmlE9UpMn7qy0JSEGdnlHWuggsM/PpRNkMZpnjj1F8ShqnJjZh0Sm2Zq0C3d6KrgUm4Hnc/TX4qrkpUxD0CdWPIiRgOIQVLTyo/DlrNOa/dvdm1lyC9CUmHVUGLWPdJDFrWxQJLLrlos2vjGmgrQP+U6lkn4yLqqb9A7/FCfQtF3DosnxJ1w5+QebBTmywQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vldEp5cPkqnDwW7G40ROQ0eKtPmMp+mCdbLx2ySRGkg=;
 b=b9I8vRLXExGMxBYAmm0jucUsZzR7kRs0/k+eGbEq7sJ7lE2asH66AT3gDn6qeWxHZlRk7cU70/10hofhZHlaISLsAFvqtD8kBlUYChKu+OR+k8mgtPMri7eDYEUdzFP7jWCWJLA2vQXE16W2T/Kw41KumF1cDqIbIaHB0/6TW86hfWGB9VBGU+XPHRUMK/TyLnUWUyPZchkBTaF3D3jQKSLBZ1nbifVTUlCy5+LHPL02+7wRH+wtYK1dlzsOUH3tJ+TTGFongKs092dT/d3Av15fax4EK9ho5nysT9Bh/s4QKoEjeoixndFO1o/rRX89bpHIWjteNrDYo2RUJbCoyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from DM6PR02MB4058.namprd02.prod.outlook.com (2603:10b6:5:9f::19) by
 BL3PR02MB9034.namprd02.prod.outlook.com (2603:10b6:208:3bd::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.38; Fri, 9 Feb 2024 19:26:43 +0000
Received: from DM6PR02MB4058.namprd02.prod.outlook.com
 ([fe80::9a92:5351:474:b845]) by DM6PR02MB4058.namprd02.prod.outlook.com
 ([fe80::9a92:5351:474:b845%3]) with mapi id 15.20.7249.039; Fri, 9 Feb 2024
 19:26:43 +0000
From: "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Sean Christopherson
	<seanjc@google.com>
CC: "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>,
        Nick Desaulniers
	<ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Peter
 Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
Thread-Topic: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on
 gcc-11 (and earlier)
Thread-Index: AQHaW3n0uKIKGks820iKFMFkm+8R77ECP/kwgAALgQCAAA1bAIAAA4EAgAAIiNA=
Date: Fri, 9 Feb 2024 19:26:43 +0000
Message-ID: 
 <DM6PR02MB40580E317C24E87B319CD748B84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
References: <20240208220604.140859-1-seanjc@google.com>
 <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com>
 <CAHk-=whGn5j-1whM66VWJ=tVmpMFO8Q91uuFAJUXa5hG-PWdxA@mail.gmail.com>
In-Reply-To: 
 <CAHk-=whGn5j-1whM66VWJ=tVmpMFO8Q91uuFAJUXa5hG-PWdxA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR02MB4058:EE_|BL3PR02MB9034:EE_
x-ms-office365-filtering-correlation-id: 8e09326a-5d09-4f2f-bff8-08dc29a50c6f
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 kai1YKGUCiHrwMz4f5CbtB5wi3ITB+fTFfVjjFom5NGg3GMSp3qKjAuSXVYVMYyjJtfUaCoy6aSguQj8bNVmNSimvePQKMy/RsYD/ZUas772DQb44axNUzB2oiAHosBaHzGcB+x97VbnAxwBGJtsvj7j3OPJWsB9vC8IS4IS7Mk1XjndQGynLkqf/0fcQfsAhA0JuQxoqiJju4EQmTCiqQOMumOMPOR8Cro28oJ4/EoAhQrRHvrbNMHZwG+9nKcous0C+CO0MGiW2zFwLfCx1Yz6hw6Kt8ndJt85gS4URCr8Y4nfS2lQVovI0ohHzTD5hPJe1c3Al1LGJNcclNvaTSqdh1fXTVENvddW09tT5LtrlNBj9gY/RPU9Dx66PFrGneaqS/sDhafDVyXOLsFxu+Kx87R+303/iCzcj6va3hTsput1AYWSJ0fowxHntRdShky16E1bN3RpyFyepfLwgrrtbekhxb1BGk80ZQIIsC9BE5wnK0LSf7WQ80VY0TmGuSWXDp7h5jgDh4d4HzSkvQX7fSa1q3TNYr01StagGH7XzTp11eiqUl/oqQZAYAp7yZqg3Zh/UGreMR3/S0j3FG7R1iRGKflnzGmOoETEzbU=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4058.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(366004)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(52536014)(4326008)(8936002)(8676002)(5660300002)(2906002)(83380400001)(38100700002)(33656002)(122000001)(86362001)(26005)(38070700009)(110136005)(316002)(76116006)(54906003)(66946007)(66556008)(66476007)(66446008)(64756008)(6506007)(7696005)(53546011)(71200400001)(478600001)(9686003)(966005)(55016003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?dTM4c1IyNXN3N3VXNlFsWkNRNXkycHdUOXgxYVVPeHF3RExwWmwyMlFMWUtz?=
 =?utf-8?B?YWtWYy84cll1bHVDRHNkd0VsYWNGcXcrNkRBSGlNN2dzeTRLdmxSM3RmSkty?=
 =?utf-8?B?dUl2akZyQ0tJMEd1WktkY1o2TG5lRlE3ejRlWlpwekY4b0p4a2tFRG9uZm9i?=
 =?utf-8?B?cHJnaGJXcjhCaHJ4VnpFZzJzOTBXWi93U2VndkUvMEV1OFcwcXpZRnpzQjhO?=
 =?utf-8?B?TmdsbStVbk9zRXpMZDJxUlR1TExRT2xJZEQzYmh6NGhJdTZwbVJBQ0ZmaUNl?=
 =?utf-8?B?M09WcmxxQ1A3WEhZVmREcGQrQnpSM0R6OVdXN09IazVqYktkL0VUQU15ajJC?=
 =?utf-8?B?REczWUNhajFCS0ZXQU1mTW9FMGxpUzV2cjJJTFR2bndpeFo0RkFKU1JZellR?=
 =?utf-8?B?WXlZZnN0NzNqWVZrR25XTk0zZlN4THNuTmdqTEE4MTZvTUU4S0oxeHNTdy9m?=
 =?utf-8?B?VmRNQ2tLaU5CQjNPVlVWWThUUFZhcHZUcFhXbEZyZ05XYjkzQmJBamRwSkRh?=
 =?utf-8?B?VTZDMTVOZjU3b1hsQmtvcDJLZFR4bEYraExVZlhYK2JzUittRUVqQi9SdkxS?=
 =?utf-8?B?RmZWTml5c3hQVzJQUi9UTkl1a3pLaTJRRFF2aFVIbGFyb2pwR0lXbkcybXlB?=
 =?utf-8?B?aUpaUzFqYmk4UCttVWZXMDlnYmljVFlCSC9zL3EyUk9qaU54SXFrdDBNbnVl?=
 =?utf-8?B?d1BkNkhDaWgzYStKemo4aTB6RUhxcURXU3dQdjFWQVYyVW5RV2pQZW9mZndx?=
 =?utf-8?B?NXFxOENpUG9GeU5YWThWaStRTHB1cHRYVE53SGc1QWJ3ckVYSEtienZWY3I0?=
 =?utf-8?B?L2padmpLcldFNFR1SFd0T2x4c00zaUFiQU03ekNBZjVBOVg3RTEzampSUDdu?=
 =?utf-8?B?bmtuTWhBVGNYTVZvT1pBeWNIV1lQOVNCMm9VZE16cEMvWUNtbnhrNmRJeFBk?=
 =?utf-8?B?aGhxUkV2U3JjQVBjMC8xM25sSHhROGg5bDROTUxFSXpyb0htNGdxcURMWWZq?=
 =?utf-8?B?SkM0ZkJSN0I5blk1dVh0SHFGeTRTM3M4VG9objJsc1RtUU9SOEhhK29Rc1RV?=
 =?utf-8?B?MlQ3UXQwT2RUbFRCeW11ZCswOWhENm9kR0VSZGIzMFNNL3BrcHdxcEFpM3p1?=
 =?utf-8?B?N1d2TEVmcGY1dFpodzZvYzZSdm5wTk5GcW5VamltTzRib1N1TzNxTXA3Tk1h?=
 =?utf-8?B?SWFUM1hpT1RsMVBrWlRENjJJanBVdURhazN6TzlwRnprdVRZdnN6c1dpNUM1?=
 =?utf-8?B?dXBjcHU0V3VUcDhKdThIUjV4d0lmQkRSa2xaS1h2SFRrOUl2bFMyQkdlTTlG?=
 =?utf-8?B?RnhyWExWTHpMVm14VVZxbzUwSzVhdk1qL1RsTXlkRXFhVXF0cnkvL2QyNWt4?=
 =?utf-8?B?UFJSMVlmZHhVVXF1RFliaG11RW1lYmEwNXp1NnVvUnJIVm5ZMStTV0RpTm9H?=
 =?utf-8?B?TytqVXFCQ2JVTzQ2YTM4NWhCSU5wZHVTekJsUHRZUEs3elVCVDdaMm1kK3RG?=
 =?utf-8?B?czlzSW94S0lHa2M2blc1RmpEbUlyZkoyUEJ6M1RWS21kditlOVdWQTVoRXVw?=
 =?utf-8?B?VFMxSXE5MUJOSWhwdFlnaExVUHlhR0dySWdQVFpEWnByMzJ6ck9ZUm5OLy95?=
 =?utf-8?B?enBua3pnNDlWK0VwNWgvK0k1SllIL2l3UlFyUGpNQlhQd2NDMmkwZnQvcFRC?=
 =?utf-8?B?RFVaQ2c2T1RyU1JZRHg0ZUpCQnArNlhXcks0eFE2eUpxdVQrT3R4bTVVM3Nk?=
 =?utf-8?B?NGxxZlJIUE1ZTXFtc2gzcmlKSTdrdlhPYVNycmYzOWlhZ0tjalY4c0dLV2dL?=
 =?utf-8?B?Y2kvVGpEWXRVazFka0l4Szd3YmU4L3h3QlBPUTB5WXNDMlJoKzNTMm1kOXhj?=
 =?utf-8?B?dG1mU1dEUlc1MUlHNmVZVGRFN0o3ckYvVHYwZldxS1IyS0wxeWZTOWJvSlFF?=
 =?utf-8?B?cHU0SEozUTgvWkhHL1VvWmFYRkNpWS8rcVdNbXBXeVBoK3YxZ0dRK0d0OVJt?=
 =?utf-8?B?Y1JURU5NdlorcmV2N0VlWjVNdXdZaFhNekxGTVRTbkZLaC8rRDZzVFBNMzhj?=
 =?utf-8?B?d2pQek54QUZkTXJONkpNRkZYREZEMVY1MjUxQU5DMm1ueVEwYVJUUVlWYTZ0?=
 =?utf-8?Q?6R5k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zWJf3+OXhiJq1v1eXJ2fJDsu1EgDGnsg0/6jYkO77cWu2pUgwo72q9jAhSaiwZB2ONIEHzwrdAnbU0I/MWYd8o1RMBltuqXuj7WZ/vMwSf57hyoO08l8o9IjFRLSOsoTPy97M/ZBhp9YGsIZhyTkTpaENz2qplZ47SrCdkeXDcBCHMnDDZKm2wNOzA37VOJyxO6CtP2P4zquYb5gI3pnm977eYBLpfm6Cr5uBIJm5zn92izocm+ko7u5AOrsOBVAHfsOiygrlRxL9opGGKrFedoIaNwMatRyVzZeUZjLvDvHNXE4DxMxk/4Lcqnvkf0EwaHSmCZ45vlqCLRZEWAnOiwVHOugDA+DZpXT+0kjS90UpkgaBjtgx2jVZTU18m3BnWTylee5xImGIRVs/m+eSAm+T6SMsJdXMTnE+a594HegEE+1qeJQDOjR7BOA3Em/jc/v/mq+eBKcZIDBuFzxCrmsMgyIJsrgEPFt8LT5TH/dB4xHxNhehFnOf8BGAIX69eGLXeYnnGu+VGVwIVkBnLcIJLzPqh5PIKGRxcmozfVvbXc62ZezxjERJyiCxMoNJ1lSGEM32AbY+CdT6Gcv5jkwonyl/LWhW95WtSSJx7Pu/vlI5I3QK0qYGXvVVtCr
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4058.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e09326a-5d09-4f2f-bff8-08dc29a50c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 19:26:43.4697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qX4Y9j7db0AT1YYnVDuakh3v5JKu677QGwPx1HWjFZ+UY2b8Qi+8CFMVPNoAgFO47a02Hl0u/30Uv5KcdXMYng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB9034
X-Proofpoint-GUID: Y7iTLjVPwJeUG5NdAwF5Uv8q1y43fBbL
X-Proofpoint-ORIG-GUID: Y7iTLjVPwJeUG5NdAwF5Uv8q1y43fBbL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-09_16,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 clxscore=1015 bulkscore=0 mlxlogscore=743
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2401310000 definitions=main-2402090142

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgRmVicnVhcnkgOSwg
MjAyNCAxMDo1NiBBTQ0KPiBUbzogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5j
b20+DQo+IENjOiBBbmRyZXcgUGluc2tpIChRVUlDKSA8cXVpY19hcGluc2tpQHF1aWNpbmMuY29t
PjsgTmljayBEZXNhdWxuaWVycw0KPiA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBNYXNhaGlybyBZYW1hZGENCj4gPG1hc2FoaXJveUBrZXJu
ZWwub3JnPjsgUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPjsNCj4ga3ZtQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBLY29uZmlnOiBFeHBsaWNpdGx5
IGRpc2FibGUgYXNtIGdvdG8gdy8gb3V0cHV0cyBvbiBnY2MtMTENCj4gKGFuZCBlYXJsaWVyKQ0K
PiANCj4gT24gRnJpLCA5IEZlYiAyMDI0IGF0IDEwOjQzLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IFdlJ3ZlIHJlbW92ZWQgdGhh
dCB3b3JrYXJvdW5kIGluIGNvbW1pdCA0M2MyNDllYTBiMWUgKCJjb21waWxlci0NCj4gZ2NjLmg6
DQo+ID4gPiByZW1vdmUgYW5jaWVudCB3b3JrYXJvdW5kIGZvciBnY2MgUFIgNTg2NzAiKSwgSSdt
IHdvbmRlcmluZyBpZiBtYXliZQ0KPiA+ID4gdGhhdCByZW1vdmFsIHdhcyBhIGJpdCBvcHRpbWlz
dGljLg0KPiA+DQo+ID4gRldJVywgcmV2ZXJ0aW5nIHRoYXQgZG9lcyByZXN0b3JlIGNvcnJlY3Qg
YmVoYXZpb3Igb24gZ2NjLTExLg0KPiANCj4gSG1tLiBJIHN1c3BlY3Qgd2UnbGwganVzdCBoYXZl
IHRvIHJldmVydCB0aGF0IGNvbW1pdCB0aGVuIC0gYWx0aG91Z2ggcHJvYmFibHkNCj4gaW4gc29t
ZSBmb3JtIHdoZXJlIGl0IG9ubHkgYWZmZWN0cyB0aGUgInRoaXMgaGFzIG91dHB1dHMiDQo+IGNh
c2UuDQo+IA0KPiBXaGljaCBpcyBtdWNoIGxlc3MgY29tbW9uIHRoYW4gdGhlIG5vbi1vdXRwdXQg
ImFzbSBnb3RvIiBjYXNlLg0KPiANCj4gSXQgZG9lcyBjYXVzZSBnY2MgdG8gZ2VuZXJhdGUgZmFp
cmx5IGhvcnJpZmljIGNvZGUgKGFzIG5vdGVkIGluIHRoZSBjb21taXQpLCBidXQNCj4gaXQncyBh
bG1vc3QgY2VydGFpbmx5IHN0aWxsIGJldHRlciBjb2RlIHRoYW4gd2hhdCB0aGUgbm9uLWFzbS1n
b3RvIGNhc2UgcmVzdWx0cw0KPiBpbi4NCj4gDQo+IFdlIGhhdmUgdmVyeSBmZXcgdXNlcyBvZiBD
Q19IQVNfQVNNX0dPVE9fT1VUUFVUIChhbmQgdGhlIHJlbGF0ZWQNCj4gQ0NfSEFTX0FTTV9HT1RP
X1RJRURfT1VUUFVUKSwgYnV0IHVuc2FmZV9nZXRfdXNlcigpIGluIHBhcnRpY3VsYXINCj4gZ2Vu
ZXJhdGVzIGhvcnJpZCBjb2RlIHdpdGhvdXQgaXQuDQo+IA0KPiBCdXQgaXQgd291bGQgYmUgcmVh
bGx5IGdvb2QgdG8gdW5kZXJzdGFuZCAqd2hhdCogdGhhdCBzZWNvbmRhcnkgYnVnIGlzLCBhbmQN
Cj4gdGhlIGZpeCBmb3IgaXQuIEp1c3QgdG8gbWFrZSBzdXJlIHRoYXQgZ2NjIGlzIHJlYWxseSBm
aXhlZCwgYW5kIHRoZXJlIGlzbid0IHNvbWUNCj4gcGVuZGluZyBidWcgdGhhdCB3ZSBqdXN0IGtl
ZXAgaGlkaW5nIHdpdGggdGhhdCBleHRyYSBlbXB0eSB2b2xhdGlsZSBhc20uDQo+IA0KPiBBbmRy
ZXc/DQo+IA0KDQpMZXQgbWUgZmlyc3Qgc3RhdGUgaW5saW5lLWFzbSB3aXRob3V0IG91dHB1dCBo
YXMgYWx3YXlzIGJlZW4gdm9sYXRpbGU7IGBhc20gZ290b2Agb3Igbm90ICh0aGlzIGhhcyBiZWVu
IHRydWUgc2luY2UgMi45NS4zIG9yIGV2ZW4gYmVmb3JlKS4NClRoZSBpc3N1ZSBpcyB3aXRoIGFu
IG91dHB1dCBpbmxpbmUtYXNtIGlzIG5vIGxvbmdlciB2b2xhdGlsZS4gQnV0IHRoZSBkb2N1bWVu
dGF0aW9uIG9mIEdDQyBzdGF0ZWQgYWxsIGBhc20gZ290b2Agd2FzIHZvbGF0aWxlLiANClNvIHRo
ZSBzaWRlIGVmZmVjdCBvZiBtYWtpbmcgYWxsIGBhc20gZ290b2AgYXMgdm9sYXRpbGUgZG9lcyBo
YXZlIGFuIGVmZmVjdCBvbiB0aGUgb25lcyB3aXRob3V0IGFuIG91dHB1dCBzaW5jZSB0aGV5IHdl
cmUgYWxyZWFkeSB0cmVhdGVkIGludGVybmFsbHkgYW5kIHRyZWF0ZWQgc2ltaWxhcmx5IHRvIHRo
ZSBpbmxpbmUtYXNtIHdpdGhvdXQgYW4gb3V0cHV0Lg0KVGhlIGZpeCB0aGF0IHdhcyBkb25lIHRv
IEdDQyB3YXMgbm93IHRyZWF0IGFsbCBgYXNtIGdvdG9gIGFzIHZvbGF0aWxlIGluc3RlYWQgb2Yg
anVzdCB0aGUgb25lcyB3aXRob3V0IG91dHB1dC4NClNvIGJhc2ljYWxseSB3aGF0IHdvdWxkIGhh
cHBlbiBpcyBpbnRlcm5hbGx5IEdDQyB3b3VsZCByZW1vdmUgdGhlIGBhc20gZ290b2Agd2l0aCBh
biBvdXRwdXQgaWYgdGhlIG91dHB1dCB3YXMgdW51c2VkLiBUaGlzIHdvdWxkIGNhdXNlIGhhdm9j
IGluIHRoZSBpbnRlcm5hbCBzdGF0ZSBvZiBHQ0MgYmVjYXVzZSB0aGUgQ0ZHIHdvdWxkIG5vdCBi
ZSB1cCB0byBkYXRlIHRvIHdoYXQgdGhlIHJlc3Qgb2YgdGhlIElSIHdhcy4gDQoNCk9oIGFuZCB0
aGVyZSB3YXMgYSBidWcgaW4gR0NDIDEyLjEuMC0xMi4zLjAsIGFuZCBHQ0MgMTMuMS4wIHJlbGVh
c2VzIHdoaWNoIG1pZ2h0IGJlIHRoZSByZWFzb24gd2h5IGZvbGtzIGFyZSBoaXR0aW5nIGlzc3Vl
cyBldmVuIHdpdGggdGhlIHZvbGF0aWxlIGFkZGVkIGJhY2ssIGh0dHBzOi8vZ2NjLmdudS5vcmcv
YnVnemlsbGEvc2hvd19idWcuY2dpP2lkPTExMDQyMCB3YXMgdGhlIGZpeCB0aGVyZS4gDQoNCk5v
dGUgdGhlcmUgd2FzL2lzIGEgbmV3IGRpZmZlcmVudCAgZm9yIGBhc20gZ290b2Agd2FzIGZpeGVk
IGluIHRoZSBwYXN0IGZldyB3ZWVrcyB3aGVyZSBzb21lIG9mIHRoZSBvcHRpbWl6YXRpb25zIHdh
cyBub3QgcmVhZHkgdG8gaGFuZGxlIHRoZW0gKGh0dHBzOi8vZ2NjLmdudS5vcmcvYnVnemlsbGEv
c2hvd19idWcuY2dpP2lkPTExMDQyMik7IHRoaXMgd2FzIGp1c3QgZml4ZWQgb24gYWxsIG9mIHRo
ZSBvcGVuIHJlbGVhc2UgYnJhbmNoZXMgYnV0IE5PVCBpbiBhbnkgcmVsZWFzZSB5ZXQ7IGl0IHdp
bGwgYmUgaW4gMTEuNS4wLCAxMi40LjAsIDEzLjMuMCBhbmQgMTQuMS4wLg0KDQoNCg0KPiAgICAg
ICAgICAgICAgICAgICAgTGludXMNCg==

