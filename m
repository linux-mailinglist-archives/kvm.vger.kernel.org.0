Return-Path: <kvm+bounces-7405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 193F5841980
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C429B2882F6
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0348E36AE5;
	Tue, 30 Jan 2024 02:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="oIM7QiU1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394D1364C6
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 02:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706582685; cv=fail; b=RMOhi38yd4PHKSKX375wjGstnhKU9gkK9CPqGhYQFctdDw3BlAS4K4m1B7ZRIJgaw5YWfvxhY3Wwa7B+yoVPH2zw8PnbU5Zi7xz+YQxVv/RIQqCnD6xwW9z4wvVVGyV5K3NMyq6NeuKZkjEmlcKOWo1YH36yrl9KkAMaFz/Y3pI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706582685; c=relaxed/simple;
	bh=v4/DPUGnv2NVttHk9/bNa9EH1La+0VOg5BuA1W+8Btw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hv08jK/nYTvPkLYwSsMFUequtJrlzzcGIDsNsnlQojk7OmDzK+LZ9HIiW1J/YKQm1TfowsB6AXr2ItWArK6tajhSqESKU8z30PqYgR8tf8DeLF7J2jdJOsJJrLVzVSBSmVnopNQ4PHoqhiJaZtvPekC8Gk2uTMwyMXcjYAKPgUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=oIM7QiU1; arc=fail smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40U2A0KN016381;
	Tue, 30 Jan 2024 02:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=v4/DPUGnv2NVttHk9/bNa9EH1La+0VOg5BuA1W+8Btw=; b=oI
	M7QiU1EJSrXReJ+GWupxWus+xyT/0q1wUIT2mSIYJrCE0VkY8IM7K5WOTT2gwPcv
	5gJbyJTxHUL0EQuiKvEnrk8T6de/TV3rOrVDliAS3u6E9bm4fFnD3Mxw8mjxXy/N
	rdRvFSAo8B0SOsC3JLYIUPRkqF7F2ReVtxvw0/nIWYvWc3SxFetT56P+FdvgGvoF
	LmFQqqIxxcaBNxL+4pFXcmQBsXhBCrxFsoYhx7n3J0KYzlQgCkSlMEiBYqgbmOlC
	3jNkHHXPZRuoxvLAW2eY4pGp4QLVibFCCBJ8Otz99vMf5uiGvlA+ewbJStg3mRDJ
	qb/Hpl5m0QDcqDAZNjSw==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3vxr2v01pc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jan 2024 02:44:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuYzoE1t6GuHPxPyPlVbRw30a3x0WQKF3CySHKAVPmtogcAp+BgeTFGH1UtW8+raunluwX3gYWWMQ1jkzv9InqQWX4h0/cj472XDmNVY8x/XgJ16zxgvP0kBzOnx12NMuNOJ4tl3oDzrWdr8jfH+/SGKdUlIvaiRFVPu8uSOHzEGiNN4tcR5ZuUpo1BZW3WozJWVUi2boC+oCRC/4BMKHuRjliRBCodY1w73Wn924BQUryvbqOMeWlvAFJDLDvc9xcBic7MArb70kUwslyM7VJ4BC0OKP8pL4J5N7mlg/S/z10JoNWEq4vRsz+nwh6ljBFucsd8k4HVf1SY7A8irsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4/DPUGnv2NVttHk9/bNa9EH1La+0VOg5BuA1W+8Btw=;
 b=LmImrgsKbWCFmMxG6wZ0S4zT3fzJEocCgiEw//Z1thBIFXChwbsLzOARyYRGQMgnQWk/4ycQpMaJBSjanHNQu+px2zDA7gvxClwA+oosGE2MBYOjdAiC1NbHJKW1m8a3ELjnJtDcTEeFflXJeBIBk00TUOdK8uRq6xcQ96uomGoJtGFUm8pPFhh+f//MwURKNjnh5pVt1loUSZwhSsgSPVNNPH74q6LlSB9nLuZgqt/HXws+7pQNs1n+tRiyifj8TvM8/ATbZEWDJn67J5vLHny52l7jkLzGwhujC/2I2RSDA/5QvDvm5sMKCQH4pjiFRzfzH/US/2aiL0AlqWfJDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from CH3PR02MB10247.namprd02.prod.outlook.com
 (2603:10b6:610:1c2::10) by CH3PR02MB10036.namprd02.prod.outlook.com
 (2603:10b6:610:19d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 02:44:22 +0000
Received: from CH3PR02MB10247.namprd02.prod.outlook.com
 ([fe80::1e37:59f7:9ae:2058]) by CH3PR02MB10247.namprd02.prod.outlook.com
 ([fe80::1e37:59f7:9ae:2058%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 02:44:22 +0000
From: Brian Cain <bcain@quicinc.com>
To: =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
        "qemu-s390x@nongnu.org"
	<qemu-s390x@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-ppc@nongnu.org"
	<qemu-ppc@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Richard
 Henderson <richard.henderson@linaro.org>
Subject: RE: [PATCH v3 11/29] target/hexagon: Prefer fast cpu_env() over
 slower CPU QOM cast macro
Thread-Topic: [PATCH v3 11/29] target/hexagon: Prefer fast cpu_env() over
 slower CPU QOM cast macro
Thread-Index: AQHaUtK3Ru8qxvWcMUCg4muoD+zR/rDxprTw
Date: Tue, 30 Jan 2024 02:44:21 +0000
Message-ID: 
 <CH3PR02MB102478EDAEB87976969F264AFB87D2@CH3PR02MB10247.namprd02.prod.outlook.com>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-12-philmd@linaro.org>
In-Reply-To: <20240129164514.73104-12-philmd@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR02MB10247:EE_|CH3PR02MB10036:EE_
x-ms-office365-filtering-correlation-id: 3495ca8e-fd3e-4dc5-8db3-08dc213d5d2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Zt1LsmTCSUV9ySvBiefzKsZdCwBaeo7JzzO9iDopoTm4VUXvyACbX7atKqGHKBTXMw0UtGMQbQP6yHw56CQy+eGdGFkduoxPzLf2C5AtVZ9BYOlA5dPAuAiWnX0Qp9guJgoWdfcHzO9nRqs5wx58PnW2c9/9lvkjWNAYn1AxpdANfdWbe3oAnv910mk+YaF8l12mslPXjHBQUmmIbQszuIsj2oQDOyU8lFmDl6+T2OF2EPpiTb3N6gmw1uihIokXTy6GSVodHpNtVE79mVTYEaWFUmAZ0IjWql6UkAaKJ4ETob9lReRgzcd9x7JaSAcYI88ht+1lA9XttEs0ndcYdNpc1VfYqpjiI8PdQMVzssFF/4TQUZA/aKBmHWIIrQpeKqR1rPtrPtGvBTywO/4QnOpLhk00/q1uR7TwCOjaC7uxfrZ9TLFeCunMBvDZjRdzZ9eVIuqLkE5SAxQPQa85SawrY7i/HcUJUY6Kb8Mh/yaBmwvnE8VLGLT7ibthwT5sNrcXnzAI8OjgjRTLQuIu5dRbpcWXSgBk4ZRTzWWNFnZ5sJouLnvk3OadskHpQxbnpMSaJ67jxfGYnGrAFUWkenED3wgKb0Y+Kyb03h8HcSYK7OUkC1gzjltRTVagGyxlfDG4xzYeMqbv6qXS7WHE0V8ZtvSTrkqi8ho9Or4tGm0=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR02MB10247.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230273577357003)(230922051799003)(230173577357003)(64100799003)(1800799012)(451199024)(186009)(55016003)(83380400001)(33656002)(86362001)(38070700009)(122000001)(66556008)(4326008)(9686003)(38100700002)(26005)(6506007)(7696005)(52536014)(66946007)(478600001)(76116006)(2906002)(41300700001)(8676002)(110136005)(316002)(66476007)(64756008)(54906003)(53546011)(71200400001)(66446008)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?U1VYWHdaUWwrOE1GVHl1Y3RSRVZJMXcySHNTYUdLZXptcU9Sc1p1NVdjVFNT?=
 =?utf-8?B?NldGM1loWUgxYURQS3o2aXRPWjc4cCs2TVE2RTU1SWx4ZVduS3VYeEk3azZ2?=
 =?utf-8?B?a1FGM2tlRGRXWm1xcGhMV0c2SXI0SnRwdHpISkZTSTJ1Skp0NFlYMGV3UjlL?=
 =?utf-8?B?dG82dHBjcFUweW1hUk1LalhGK2Y4dk55WGdwSE1GUUxHUXZRT1llR0ZOMlVw?=
 =?utf-8?B?TnBBMW1KVCtycDNDeDB3ekNtVlFLY1ZGeW51ck5UaDkyQkhkaU1pbkNrakRz?=
 =?utf-8?B?L2Fwcm5Jb3JiRmYybWZzRGprdDh6cUxkVXU0TWw4R2h3endwekh6ejczSDhJ?=
 =?utf-8?B?WEs5YnlJTUhtVTI5b2MwcTN4eE41SWtJd2F1eDQrT0ZBbG9NZGNpa1VtaDV4?=
 =?utf-8?B?c0xUZnZ1YVBmSjVoczQ2Qmp1dks0aW54WEd6WDZBUmJxNmxDc1RMOUpyOFox?=
 =?utf-8?B?NS8zSkw3SW1Va1dOS2JhMnp1Mjc4MWhsVGtoU2dsNTlaRStnWjhlQ2xZOUtK?=
 =?utf-8?B?WEpBY2I4ZTUxSmtWQURJWWtrQThqV0YrSkZvNDYyamQwMmJNMHJ2Y0NoMUFq?=
 =?utf-8?B?NCtWWXhNZDdid09Na2ZuRlhBSFNXQ21wUUdCV3VVT2tvcW9QQ3Z0Q1BhQU4w?=
 =?utf-8?B?bjRMVjRFUC9oUWJwc0ZSUXJRcUQzbVN4TTlJR3o4enZCZFJjblZiRDRKSk1j?=
 =?utf-8?B?Sm52NzNaNzhWL3ZLMDZYVG4rZmFYekI2WWF5aEg1Wk9UczY4N3JJRURJUGxu?=
 =?utf-8?B?WExRVmhURGhHWkR4bmszaXFxZU1TYTRYRlNkQ2lsWkFxUW9NQ013WFlTUXZE?=
 =?utf-8?B?QnFrVnBySDREVzE0TFRsc21nRk1DWkMwd29LSjlnS2hqYm1lcnJnMVl5d2dF?=
 =?utf-8?B?RVpQcjJlYldLMEZvdWR3eVNZUUxNQmtOMlR1ZjBjcE0yak52bmFjdEtlaWdL?=
 =?utf-8?B?Vk5ndGdQLzNrUHU1aEhwbmhZb3lIR2tHWDFMRVR4ZmtOMWxlZjZTS0MrcWRw?=
 =?utf-8?B?Z1RhbUhPclNxeVBCWHd1R1M1Zk5rZmROaVpmUkU4bkRvMTZoZ1RmOVBOc2tj?=
 =?utf-8?B?NVJyV20vckVKQTNGY1lYWU1iVUk5OHpqRVJmY0N2aWJVbHpVZWFuQnFlc3Nq?=
 =?utf-8?B?djlEZlNSellKN3FhRXVlR0JvTmNvUHVZZDVQZXBHSnZESlk2VFpMamJmWnEx?=
 =?utf-8?B?WGVpWDZKbFNkNDlNVldYNDlKejVsZHhma1ZLRHJWbnR5WVFueTY1WjJ6YlRJ?=
 =?utf-8?B?dUpTem9VT3JCMWJuSXp5ek9uRmZsMkcycjZHVmZ1NkVYNHFNOGVaRndSenc3?=
 =?utf-8?B?ZWRLWmRtK3lxSXNGcnlINFI5di92VkVMUmpYNzA0dThMU0p4L2p6VUwycjFI?=
 =?utf-8?B?ekIrRGx0WFgzSytxVXBDU0hVT0Nya0ZBSDRYWmQrUEhLWWxSV1NZTHBtOHIz?=
 =?utf-8?B?UDBuYjRqV1A5OFJ0T3pqU2x6YXVST1BzQUhUM2EyY1d5a1FCVDNrbVBza2kr?=
 =?utf-8?B?SDdZL21MN3VsM3dRMHBmTGRsOUhWV3RWMGFjaGdLTGJnRE9VYUsyZU5pWXlM?=
 =?utf-8?B?MytqY3dydnZQM3VZci8wMCt5WGxCN3Fwb0FUQVp6aUpEbzU4STFpeWdDL0p0?=
 =?utf-8?B?WTMxQlEyNjgyQ0RWcjB2R3pqT2FvN2M3eVFMSEF3MWVxNEFLNDRwK2xmcXFM?=
 =?utf-8?B?L3Zya1lVd3V5OEJOZkRMc0pDYjY0TzVtVjVGN0lZS2lKemZBSHdTMW01cnhM?=
 =?utf-8?B?Z2FzMm5ubURCVXlwNW5pSEgzSmloZGorSWthT2VlSktMRzlJalhLRmp2OWNK?=
 =?utf-8?B?ZGlXV1NCNURjczNnYk5Nd2FsMXk5WVE4Q285RDNIbEFUQkxtS3ZNUmRobmxy?=
 =?utf-8?B?NmxrTVg1Z20ybjJXZGs5ZlF4bjl0WDNkclg2bVNMdkYwMHpRaDQ1SDZmOGlD?=
 =?utf-8?B?ZGlYNGtEZ1pLZmVoQ1NLdEhPRHZ5d2xGaVpkRGxPUXJXK05zaGFGQjR5dHg3?=
 =?utf-8?B?UVFUTGF4SkgvVDRmRlRyZUdudnZRSHhKQUYvQ0pncWh4cC9GQXJwZkUwZHpC?=
 =?utf-8?B?aWZYaTFSTVIzM29hRHJ5ZC84bDF4UWZaVldCSkJZdEwyVEoxNjhEMUV5TmtE?=
 =?utf-8?Q?Y3jM=3D?=
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
	Jm2jRkoGJJmEYePOJA0tOIpMCMuygAR2i2rqGJFhUsJNasqDkDhWFu/++ggDdgkVEND8TmauuF6yrBqCLtTbGZM9xMNA+xPCmfVVGWyx8dfmClj/otG75Ui91woE2F9P3tTBjIRK8IT9XLUFdR2FwFa9C9paBpcM41Yuy/XjwASkyQRhB3FaDPeDzorccgXZ7aB9/LIuFGg0TIb2kXvG2bdghtMyLAlDOpRhFIKtXP4KzE8Z2xYsAcOCpmYPCvWiVyVDIYkcB8ThbxH2NHNllor+RCRvSyMjTGqWBWSr1TddvaUDoWu+bB0I3YFnAo1bWWaEFZBVOtSLd8MkBRmMgPlOFABzv6inZbQASmwNFHc/aNyjOwBXLFY903KiA3Oh7/BMjkh+BXqA8gODbmH3bhAuoAJgRLtUwUoA5u9/+eZmtZBQHV9xLBsy/zjvLswhq+TRXAbMnCun3h+fgVASav9PS58DCd+q5t8+kGSQQi/XNFlM9Xs79uuqh1n7S1h8F2MlznijzjPA4G10dv+AMP3bu3RrW6tRo4+ZiV4JPkSVvBkpethGZHPZFHNc1IDjlB9oLwzo6afYga6ON9/1zGpLBK3pH80/Ajy/yP3iy/y0yMFaV6M2XT2LbwS+yz4k
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR02MB10247.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3495ca8e-fd3e-4dc5-8db3-08dc213d5d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2024 02:44:21.9661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kocsbhwx8INYRC3Afxw5E6Wc+CWEmheJ8F4AZHF8kTH+lZdviIxP7f//zwVmjkuecdDp90H7BFx6XsDlJHvlVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10036
X-Proofpoint-GUID: R1Ku94LyJJIhAN6scrRdqR5SDYJprXHA
X-Proofpoint-ORIG-GUID: R1Ku94LyJJIhAN6scrRdqR5SDYJprXHA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_15,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=733
 impostorscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2401190000 definitions=main-2401300018

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBoaWxpcHBlIE1hdGhpZXUt
RGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDI5LCAy
MDI0IDEwOjQ1IEFNDQo+IFRvOiBxZW11LWRldmVsQG5vbmdudS5vcmcNCj4gQ2M6IHFlbXUtcmlz
Y3ZAbm9uZ251Lm9yZzsgcWVtdS1zMzkweEBub25nbnUub3JnOyBQYW9sbyBCb256aW5pDQo+IDxw
Ym9uemluaUByZWRoYXQuY29tPjsga3ZtQHZnZXIua2VybmVsLm9yZzsgcWVtdS1wcGNAbm9uZ251
Lm9yZzsNCj4gcWVtdS1hcm1Abm9uZ251Lm9yZzsgUmljaGFyZCBIZW5kZXJzb24gPHJpY2hhcmQu
aGVuZGVyc29uQGxpbmFyby5vcmc+Ow0KPiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1k
QGxpbmFyby5vcmc+OyBCcmlhbiBDYWluDQo+IDxiY2FpbkBxdWljaW5jLmNvbT4NCj4gU3ViamVj
dDogW1BBVENIIHYzIDExLzI5XSB0YXJnZXQvaGV4YWdvbjogUHJlZmVyIGZhc3QgY3B1X2Vudigp
IG92ZXIgc2xvd2VyDQo+IENQVSBRT00gY2FzdCBtYWNybw0KPiANCj4gV0FSTklORzogVGhpcyBl
bWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiBRdWFsY29tbS4gUGxlYXNlIGJlIHdhcnkg
b2YNCj4gYW55IGxpbmtzIG9yIGF0dGFjaG1lbnRzLCBhbmQgZG8gbm90IGVuYWJsZSBtYWNyb3Mu
DQo+IA0KPiBNZWNoYW5pY2FsIHBhdGNoIHByb2R1Y2VkIHJ1bm5pbmcgdGhlIGNvbW1hbmQgZG9j
dW1lbnRlZA0KPiBpbiBzY3JpcHRzL2NvY2NpbmVsbGUvY3B1X2Vudi5jb2NjaV90ZW1wbGF0ZSBo
ZWFkZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhp
bG1kQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgdGFyZ2V0L2hleGFnb24vY3B1LmMgICAgIHwgMjUg
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgdGFyZ2V0L2hleGFnb24vZ2Ric3R1Yi5jIHwg
IDYgKystLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2hleGFnb24vY3B1LmMgYi90YXJnZXQv
aGV4YWdvbi9jcHUuYw0KPiBpbmRleCAwODVkNmMwMTE1Li4xN2EyMmFhN2E1IDEwMDY0NA0KPiAt
LS0gYS90YXJnZXQvaGV4YWdvbi9jcHUuYw0KPiArKysgYi90YXJnZXQvaGV4YWdvbi9jcHUuYw0K
PiBAQCAtMjM2LDEwICsyMzYsNyBAQCBzdGF0aWMgdm9pZCBoZXhhZ29uX2R1bXAoQ1BVSGV4YWdv
blN0YXRlICplbnYsDQo+IEZJTEUgKmYsIGludCBmbGFncykNCj4gDQo+ICBzdGF0aWMgdm9pZCBo
ZXhhZ29uX2R1bXBfc3RhdGUoQ1BVU3RhdGUgKmNzLCBGSUxFICpmLCBpbnQgZmxhZ3MpDQo+ICB7
DQo+IC0gICAgSGV4YWdvbkNQVSAqY3B1ID0gSEVYQUdPTl9DUFUoY3MpOw0KPiAtICAgIENQVUhl
eGFnb25TdGF0ZSAqZW52ID0gJmNwdS0+ZW52Ow0KPiAtDQo+IC0gICAgaGV4YWdvbl9kdW1wKGVu
diwgZiwgZmxhZ3MpOw0KPiArICAgIGhleGFnb25fZHVtcChjcHVfZW52KGNzKSwgZiwgZmxhZ3Mp
Ow0KPiAgfQ0KPiANCj4gIHZvaWQgaGV4YWdvbl9kZWJ1ZyhDUFVIZXhhZ29uU3RhdGUgKmVudikN
Cj4gQEAgLTI0OSwyNSArMjQ2LDE5IEBAIHZvaWQgaGV4YWdvbl9kZWJ1ZyhDUFVIZXhhZ29uU3Rh
dGUgKmVudikNCj4gDQo+ICBzdGF0aWMgdm9pZCBoZXhhZ29uX2NwdV9zZXRfcGMoQ1BVU3RhdGUg
KmNzLCB2YWRkciB2YWx1ZSkNCj4gIHsNCj4gLSAgICBIZXhhZ29uQ1BVICpjcHUgPSBIRVhBR09O
X0NQVShjcyk7DQo+IC0gICAgQ1BVSGV4YWdvblN0YXRlICplbnYgPSAmY3B1LT5lbnY7DQo+IC0g
ICAgZW52LT5ncHJbSEVYX1JFR19QQ10gPSB2YWx1ZTsNCj4gKyAgICBjcHVfZW52KGNzKS0+Z3By
W0hFWF9SRUdfUENdID0gdmFsdWU7DQo+ICB9DQo+IA0KPiAgc3RhdGljIHZhZGRyIGhleGFnb25f
Y3B1X2dldF9wYyhDUFVTdGF0ZSAqY3MpDQo+ICB7DQo+IC0gICAgSGV4YWdvbkNQVSAqY3B1ID0g
SEVYQUdPTl9DUFUoY3MpOw0KPiAtICAgIENQVUhleGFnb25TdGF0ZSAqZW52ID0gJmNwdS0+ZW52
Ow0KPiAtICAgIHJldHVybiBlbnYtPmdwcltIRVhfUkVHX1BDXTsNCj4gKyAgICByZXR1cm4gY3B1
X2VudihjcyktPmdwcltIRVhfUkVHX1BDXTsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgdm9pZCBoZXhh
Z29uX2NwdV9zeW5jaHJvbml6ZV9mcm9tX3RiKENQVVN0YXRlICpjcywNCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgVHJhbnNsYXRpb25CbG9jayAq
dGIpDQo+ICB7DQo+IC0gICAgSGV4YWdvbkNQVSAqY3B1ID0gSEVYQUdPTl9DUFUoY3MpOw0KPiAt
ICAgIENQVUhleGFnb25TdGF0ZSAqZW52ID0gJmNwdS0+ZW52Ow0KPiAgICAgIHRjZ19kZWJ1Z19h
c3NlcnQoIShjcy0+dGNnX2NmbGFncyAmIENGX1BDUkVMKSk7DQo+IC0gICAgZW52LT5ncHJbSEVY
X1JFR19QQ10gPSB0Yi0+cGM7DQo+ICsgICAgY3B1X2VudihjcyktPmdwcltIRVhfUkVHX1BDXSA9
IHRiLT5wYzsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgYm9vbCBoZXhhZ29uX2NwdV9oYXNfd29yayhD
UFVTdGF0ZSAqY3MpDQo+IEBAIC0yNzksMTggKzI3MCwxNCBAQCBzdGF0aWMgdm9pZCBoZXhhZ29u
X3Jlc3RvcmVfc3RhdGVfdG9fb3BjKENQVVN0YXRlDQo+ICpjcywNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgVHJhbnNsYXRpb25CbG9jayAqdGIsDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHVpbnQ2NF90
ICpkYXRhKQ0KPiAgew0KPiAtICAgIEhleGFnb25DUFUgKmNwdSA9IEhFWEFHT05fQ1BVKGNzKTsN
Cj4gLSAgICBDUFVIZXhhZ29uU3RhdGUgKmVudiA9ICZjcHUtPmVudjsNCj4gLQ0KPiAtICAgIGVu
di0+Z3ByW0hFWF9SRUdfUENdID0gZGF0YVswXTsNCj4gKyAgICBjcHVfZW52KGNzKS0+Z3ByW0hF
WF9SRUdfUENdID0gZGF0YVswXTsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgdm9pZCBoZXhhZ29uX2Nw
dV9yZXNldF9ob2xkKE9iamVjdCAqb2JqKQ0KPiAgew0KPiAgICAgIENQVVN0YXRlICpjcyA9IENQ
VShvYmopOw0KPiAtICAgIEhleGFnb25DUFUgKmNwdSA9IEhFWEFHT05fQ1BVKGNzKTsNCj4gICAg
ICBIZXhhZ29uQ1BVQ2xhc3MgKm1jYyA9IEhFWEFHT05fQ1BVX0dFVF9DTEFTUyhvYmopOw0KPiAt
ICAgIENQVUhleGFnb25TdGF0ZSAqZW52ID0gJmNwdS0+ZW52Ow0KPiArICAgIENQVUhleGFnb25T
dGF0ZSAqZW52ID0gY3B1X2Vudihjcyk7DQo+IA0KPiAgICAgIGlmIChtY2MtPnBhcmVudF9waGFz
ZXMuaG9sZCkgew0KPiAgICAgICAgICBtY2MtPnBhcmVudF9waGFzZXMuaG9sZChvYmopOw0KPiBk
aWZmIC0tZ2l0IGEvdGFyZ2V0L2hleGFnb24vZ2Ric3R1Yi5jIGIvdGFyZ2V0L2hleGFnb24vZ2Ri
c3R1Yi5jDQo+IGluZGV4IDU0ZDM3ZTAwNmUuLmY3NzNmOGVhNGYgMTAwNjQ0DQo+IC0tLSBhL3Rh
cmdldC9oZXhhZ29uL2dkYnN0dWIuYw0KPiArKysgYi90YXJnZXQvaGV4YWdvbi9nZGJzdHViLmMN
Cj4gQEAgLTIyLDggKzIyLDcgQEANCj4gDQo+ICBpbnQgaGV4YWdvbl9nZGJfcmVhZF9yZWdpc3Rl
cihDUFVTdGF0ZSAqY3MsIEdCeXRlQXJyYXkgKm1lbV9idWYsIGludCBuKQ0KPiAgew0KPiAtICAg
IEhleGFnb25DUFUgKmNwdSA9IEhFWEFHT05fQ1BVKGNzKTsNCj4gLSAgICBDUFVIZXhhZ29uU3Rh
dGUgKmVudiA9ICZjcHUtPmVudjsNCj4gKyAgICBDUFVIZXhhZ29uU3RhdGUgKmVudiA9IGNwdV9l
bnYoY3MpOw0KPiANCj4gICAgICBpZiAobiA9PSBIRVhfUkVHX1AzXzBfQUxJQVNFRCkgew0KPiAg
ICAgICAgICB1aW50MzJfdCBwM18wID0gMDsNCj4gQEAgLTQyLDggKzQxLDcgQEAgaW50IGhleGFn
b25fZ2RiX3JlYWRfcmVnaXN0ZXIoQ1BVU3RhdGUgKmNzLCBHQnl0ZUFycmF5DQo+ICptZW1fYnVm
LCBpbnQgbikNCj4gDQo+ICBpbnQgaGV4YWdvbl9nZGJfd3JpdGVfcmVnaXN0ZXIoQ1BVU3RhdGUg
KmNzLCB1aW50OF90ICptZW1fYnVmLCBpbnQgbikNCj4gIHsNCj4gLSAgICBIZXhhZ29uQ1BVICpj
cHUgPSBIRVhBR09OX0NQVShjcyk7DQo+IC0gICAgQ1BVSGV4YWdvblN0YXRlICplbnYgPSAmY3B1
LT5lbnY7DQo+ICsgICAgQ1BVSGV4YWdvblN0YXRlICplbnYgPSBjcHVfZW52KGNzKTsNCj4gDQo+
ICAgICAgaWYgKG4gPT0gSEVYX1JFR19QM18wX0FMSUFTRUQpIHsNCj4gICAgICAgICAgdWludDMy
X3QgcDNfMCA9IGxkdHVsX3AobWVtX2J1Zik7DQo+IC0tDQo+IDIuNDEuMA0KDQpSZXZpZXdlZC1i
eTogQnJpYW4gQ2FpbiA8YmNhaW5AcXVpY2luYy5jb20+DQo=

