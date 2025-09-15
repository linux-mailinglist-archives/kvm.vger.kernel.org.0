Return-Path: <kvm+bounces-57614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E67D5B584EC
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B8BB2003F2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B26B279DA3;
	Mon, 15 Sep 2025 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SQZv40TT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB5D2459F7
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757962017; cv=fail; b=qKg+2G3p4tJSdKWu8O0WjYoSGQMIgJGo18YxnBbHMaooa/6g7iZHgnG2f/Ue5+IDEpEJ8+uMPINK08ef9p08wwxXk+FIrtvYCNq2zQ96yyOB3SaN/UQcxzm4BlxSw5s49QU/X2qDMi6zRrGTIejnSPGk6pRZ7NRewNULY/aSGP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757962017; c=relaxed/simple;
	bh=IVSdSO6dx901fFO0scs5n1j/lC3C6zSb4WRo/zA7Yxs=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=ncm+KdHICkN0OztvG3VtsARco84OpCZbXrvGlS0CysWZDveeAb0+mcMDmy5mgPekSV51AzJo93nk0O2XEKcn3ojDUPcLLL5OjH/wVL7yyAyo8fcdR/yakKFUi+ZMn+VaJmy4LRzlu6X/hRW7UREhaev7d/OgYKYqzxCbvU/Bxls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SQZv40TT; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FBUteL023054
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 18:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=dAR6MxBWQCTYR+pWQ2k45wRaBwmSOSpWL1/FtpMrHwQ=; b=SQZv40TT
	Jusj859U0k5THBABaFz2cbf/UWkEu3pGQOywxjZsRqYAO0EzQxEQcdWu4Oe5QxC1
	4WYgBmLcGJ8VblMwXBdJ95o5N31Mo5IP8Hd4y/bTHChimYuWZvaygohoQ6F4p+Xw
	J3wZ7js/IUnkbzjLdQegHIfkGomIrRj3vL6Esf/LrjtcH2MZPCsIOnbMQ01q/R3Q
	gCK53TwOV5krusiuHcC+sWVvw/P4UJnmtU9/3ICleR8Am67JSRnO6BVAhdnK9GHo
	Wle1i9PXMlukkB7yvMhC6ekZfU5f3ES1yxRqh1yw84hN5pshSWXN9mmTXzIVPISq
	iYdDgg1CoJ3ICQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509y4pb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 18:46:55 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58FIdZcP017091
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 18:46:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509y4pb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:46:53 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58FIg4CU023648;
	Mon, 15 Sep 2025 18:46:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509y4pb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:46:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X7MjuYij1aPqocOXJP64DAM+UgHSQgCjYZz6rlW7JOEdmYbJb+CYXNDM+C3eTlhU/amr3OYmf4sY8TfkF+vn8qDWhRh0LYVXvc2X5AUrojeSxGOStgs/aPtDcRZoeXFARnr9P4y16bdYwjVDhFK9QpRKzIiWzne63LjqKLulsy0tn/d3U4u82pVnxfXA9FT28pVyw6EtDKCuamORA2Mo4JgU34m0mN6/9JJYBX9FgtbfQAUpi7neooElNNowYCfPhZVsBjBsoIRhfYm2RKE49KEQHkQvn0w6d85yF/fmF7ABHGuCMYZhmWCDruSup65HsXzlhPAOiCDIkwsdLgygcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihgHZ/pkBOj/e+FAWWElHpqoQi5eMW6AETY2yoOU5sE=;
 b=MlwazNAi/CrwqVnfr9IAtbvG7/0yDLDu9V0PZFzxjKZEjirnFmzqmaeRvJ6FauPA+ciu4MRoXkLN/Kz3GaRgREyxM6GFb3ZO74gby0b156rDOTgnw0xnT2L3MyGSJQONjoFqtm8ePvwhPrHv72XWYUlmfoeKJGAs63Mk3sZuP39ekVZ1vN5Gj0ziCpnUEIFhYPrq2i20jUtufzstMZMEzLw4jYppEDSeS7KXCHguHItB+Dj923pfTxaW8gvuGXToN4U7GrwUkZBz7YDdXCL5Qn1LaV4IoO2RLvgwxBlgoivvDjOKGgPoMLmL+V8gtteH1pdQfvtYajjTKUMlVla6FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW4PR15MB4347.namprd15.prod.outlook.com (2603:10b6:303:bc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 18:46:49 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Mon, 15 Sep 2025
 18:46:49 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lyican53@gmail.com" <lyican53@gmail.com>
CC: "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "seanjc@google.com"
	<seanjc@google.com>, Xiubo Li <xiubli@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "sboyd@kernel.org"
	<sboyd@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Thread-Topic: [EXTERNAL] [RFC] Fix potential undefined behavior in
 __builtin_clz usage with GCC 11.1.0
Thread-Index: AQHcJeu5wfTHJUHF30qNNLZu4keaVbSUllcA
Date: Mon, 15 Sep 2025 18:46:49 +0000
Message-ID: <80e107f13c239f5a8f9953dad634c7419c34e31b.camel@ibm.com>
References:
 <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
In-Reply-To:
 <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW4PR15MB4347:EE_
x-ms-office365-filtering-correlation-id: 7834dcb2-aa88-4145-7db1-08ddf4883a92
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VDBxbUxvaC9OTnNselVnckx0b2ZjYzlFWDJYREpCWTl4UEJzL29HU0F4bzBJ?=
 =?utf-8?B?Z096VFlsa2hrTXh0Y0djSnQwTWhOSURqNW5CeG5Nc0p0Z1U1UDR1S1JvelpQ?=
 =?utf-8?B?UnorR1gxa0Z6ZTZGVkFsM3RVUDRNaGRZVFFtZ0pRRnhWMXdaQ1hwSjhtZjB5?=
 =?utf-8?B?c3o4TTZiWTJCYTFVS1N5cUxMREFWNVVVdGZ0TFQ5d2svYlFZaVR4YU5xYXZM?=
 =?utf-8?B?UGhYTFVkS1J0cnlQdDByS0swTmZkbjFpQ2t4cHViTzErbHBMekZxMXgvbmNK?=
 =?utf-8?B?dnU4ZUcyQXJlNHdmUFY5VEZLMkdYSCtlMjRpSlRyU3RWWVZ4blMwM1FvQ1g5?=
 =?utf-8?B?Z0hxMTRGNlFRd0NGWWlKN3huR29YT3J4S1JlSFJtdWJBeHBuMWpYaEtDOEVt?=
 =?utf-8?B?TEJvMk9NdWsvRXFBUStiTyt0czI2YWNvOWQxUitLbmNzaWtaN2NQVGluMVJ4?=
 =?utf-8?B?ZThmR1VmdWNXdXk2MWdIVzkvU2ZIclNiUDRiTkpoSmxtczdqamJxUkxWSTJC?=
 =?utf-8?B?NmEyWVMreDJhUGF4QndWQzlQV25ZcmpYR3lCWk91NWlzK0tabVRBRUc1N0NJ?=
 =?utf-8?B?TXQ0WUl1d1p2cDlENVQxN1hIU2dGd0xTUGRkRXExUDdScmlOUzB6VmNWYmdQ?=
 =?utf-8?B?d1huZHpRUlB4c3FNeHVJdUg4Z0FZSytNbTVyYUl2cEdBRHF6UTVWN0F6TTh2?=
 =?utf-8?B?RjdnVUxzOUNyTytNYWZ0R2plT0dUQUxHUm8xQjRpTDdObFpUcmpLdHAvOUdz?=
 =?utf-8?B?S3pCSy9aTHVjYk5VSUg0RFJINWVTQTdqTDlKWkhIZ1V0UUV2dzVOanNxSkgv?=
 =?utf-8?B?TWNpdWFnSnpKSk9VeGJxTXV5K3Q4MXBoTnVuQ001eXNxeWJmaEVKaVI3b21M?=
 =?utf-8?B?SDQraFVQU3l2U3ozQlR4M3d0VDFsZTIxd2RYZ0NwWVhlbjhHaytTdDU1bllP?=
 =?utf-8?B?ajFLOEw4M3VMK0VhWTZvMVpVdEh2bXJzYXo5bXI5U3g3aTJ6L1N1OThCQ0pJ?=
 =?utf-8?B?dEFTM0xxUlhaRzhXcGpXc3FDblhNeThhOHhXbDhzRnZUeXRacmdyM3ozbDds?=
 =?utf-8?B?OHlPOGxmRGdNM1gvTUszUzR2eFdjVHU0TmRLY1UvanZuWkUxaGpMK2llcStv?=
 =?utf-8?B?NGJhMXdrZkcvOC8rc0ZFc2hjMWhZR2JiYlBLQXpYZzJ0YnRaWXN6bHlWZXBJ?=
 =?utf-8?B?VXByM2FybVAyTGNxQUxuaVpYL0JZZjVoNFN5bkFnRkNNcVRPcE5LQWlkTWx2?=
 =?utf-8?B?aG5tRGZFMENJYyt0YktXY1dCNHpYUjNBWS9iNXFRN0d5SDd1U0xRRUdWeC9s?=
 =?utf-8?B?d2l6ZlZIUzJPN2M0ZGlOWnNyVUFvUVRUR2pwYXpDTnlGTmZ0ZVoxK2M3Q1hX?=
 =?utf-8?B?UzNGdEk5b1B5aStVWHVzeVk0VGVOaERGaTBsN0drZi9TRGlrSDh3cHF6cVlE?=
 =?utf-8?B?bjJtOHJzdFA2clVCdDdYajYreDhTQ2Z3aENDeDdLUXRMSi9yZ0QvbG56bXJO?=
 =?utf-8?B?YmM2bFpiVmdGZWtMNk9ZT3EwLzd2a0l0SFRkMHlUVmljdDI1WDNDdktUVGc2?=
 =?utf-8?B?ZmhXdEdaVFBqNVBmbVBZNXA2LzB0WFI1N0lmRUVwV0kvYWo3L01FYVdNMVRS?=
 =?utf-8?B?eGJZUDZwUTBWbXJwSDBkUXluby9nanBQaCt3alp1YzVDVzZnL2YvN3hydjRo?=
 =?utf-8?B?V2poUmFYRE02VTNXQStoRE5YRDE0eE9FMTZobGVOYkl2ZGV0RWhkand0Nmha?=
 =?utf-8?B?WnYvb2t3U1d3TE1kTEhIRWZjQ1JVTkJ0SUYvOUlXaGtEVUNkT0w0aThubmFM?=
 =?utf-8?B?cWtBeGR1bS9NVlVUVjJlZWplcktlNnRURDhQYnV1eHRVUUxDYlpVb2R5WDR1?=
 =?utf-8?B?dHc0UnVudVpBNG9JRVhlNzQ3dDVYRHBPTnNIMWJBaHpJVjJjcFJoSHVaWVR0?=
 =?utf-8?B?SHNIU0pCZ1doak9tRU9kOWxrUHJOSGpFRXA3MFdrWEJ1eHhIN1h2YlV1Nk40?=
 =?utf-8?Q?H+gKy+kjUCoKxNzFxsoP4eqzZNwh5g=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UWtRTDdLYmtVd29BRlFUUHpka0EyekNQU2lEdEgxQ0pUV0poaFZKS29aWGo1?=
 =?utf-8?B?RXNlemFYUnJLU1pEay9RNmd5SVUrYkhkMVpGNGhqZUd6cFgyQm0rRmdhcFp5?=
 =?utf-8?B?R1Yzc1BLcUlEbHF6QjJGTlMxeWxnci9QTFN6aGl2N2YwdjdSN0kxbGtEcVY2?=
 =?utf-8?B?SVhBNm1UMXVkR2p3ZE92MnhSaHdCOUpiMkxRbkpaNnBRY3NiN3h4Vi80Vi9X?=
 =?utf-8?B?aVJHS0M5bEt3cHNpZjllbUJ3c0NSYVErNTg4QUZ6bC8xOHVqeWJDcmdQV2U3?=
 =?utf-8?B?VkdVWGthOHRLaTFwcmNnbzkvMGhaanZtZlgwd0VYMlBINWUzK21LN0RWZ1Fw?=
 =?utf-8?B?clcvQzNLdHZlVTRESElLdGgwZFlsY1d6MnF1YkhuUnU3OGc2ZXZZMVVjL2VV?=
 =?utf-8?B?Mmo0c2hObHBWeVZOMURrY2xhN29wOE9oakNUWHUzUjJxTHBIQVRrVkNKZzZJ?=
 =?utf-8?B?KzJqdEhGUzA3aGVNLzVxYU9MMll3d0VEbVV6MnFRYndHb21MVDlaL1hGR3pF?=
 =?utf-8?B?TTh4M0lFL1lvWDhGQjZMem42dnhBNGppZjdMaCtMakFuQnpVY0RJdm9sS2tq?=
 =?utf-8?B?eUNpZVBLTFhCLytNanp2RmROdThHa1VXR2R0Q0t1bUx6MGxHWDF4aUl6OGVm?=
 =?utf-8?B?enZtTzVmbitmL2JuVDVQeUhuay9DNTdaYUIzbVV5ZnF5SVRqQjc0a3pwWFJU?=
 =?utf-8?B?V3Q1eGkwS0g4YmJHdVlSbSsxMml1QXEwZEoyY3g4NkVzQ3JuaEZ0aTR5TVQ5?=
 =?utf-8?B?UENsbDljVE1DS3JleGluc1J6Ukl2YURvenRXWEY4dkllaU9nQnlGMmFtanpj?=
 =?utf-8?B?cDJHRmRnM0FJT2d1anJHSG5hZW1wZnlGM21wazF5NkdQNEh0ZXorREhCUlJU?=
 =?utf-8?B?YmJBSUhmUmlRZFR0anZFVW5ZTGdsMkNKcCt4clllckw4REVlMjhyVUhKbk52?=
 =?utf-8?B?Q0VISktxT1hIMVB4V21YajczN0cyNFdTY0dOZ2VqaG5yZlBxL3Qwa0Z6VFpJ?=
 =?utf-8?B?UXI0MDRCZzJsUlUxaGtObmkrRk5jOFQ4WHNZWlFiL2R3S1FJWUpyNEE3U1Rp?=
 =?utf-8?B?WmZjbEFpUWtVZWY4SEpuQ1dmNTczN2ZWYWszQkw5TTdnYVJVUm4wUXpsTkVu?=
 =?utf-8?B?TXd2bnVkanJIbW1FTWkyZCs4YmkzRDVlMmFqditpWjJrTzMrOUZla3VSNG80?=
 =?utf-8?B?aVJHN3BDV1RZSFlNNzg5cmZtWnZsRndiTkN2VFJDR3hoUkdVR2xqR0hFTDUx?=
 =?utf-8?B?UXBrVXpnV3pyb0l4QTdJOXhmN2FzNktHOTZlQS8wRmJWT1FUSnhwcEVNR3Rn?=
 =?utf-8?B?Tkl3ekNTZk1OUnF2N09sczRVRXA3bUZzcEVqeGx5a3FCOThFUW9FWE1wZkR6?=
 =?utf-8?B?ZEJGblV3WnpqOUlibW9YVTdJcDYrSGhBU1RzOVVFaG80N0JBVVNQRWJmbXd4?=
 =?utf-8?B?dG5vWGFhUnhMbDg2RGlHdUlDTU5YdExtcEJ5R1hYYkxVWnZlSTNvb2N4QitU?=
 =?utf-8?B?Ni9ha3hRNTJiSWFLaENsUk9wQmNYSGpObWp2MU9jK2hvZWx2UER5ZVRoaHdq?=
 =?utf-8?B?ZUtFSkFRR2xnNzgyNzFkajVRZ3ljMkY0cWJRMUplR0tYaDJLS3VCOXR5QXN4?=
 =?utf-8?B?RXRnK0M2aE8xcGI3NVNnNTBMcE90NStuOFpHMzlwZjdRRUpCSVVCVFYrSFFm?=
 =?utf-8?B?UXNnd0ZFVnVhVWpJaWRTOEhLOXNjSC9hNGY1d1V4anoxZlBMV09BRUJGb2kx?=
 =?utf-8?B?Ri9kbmJQajNQUDVuRkNoZi9jZGFRbWZFZEU3R0I5anVXYVJQcTV4RytyM0V1?=
 =?utf-8?B?cDJhYkpYUCtGTktnTDI4TFFoSys5ZGZxWlFRQWphRzZqRVRvYm5FaXdDK1A3?=
 =?utf-8?B?U01MaEU3VThRdzhWMHdBeWxJNXhRYUtxYUYrd1h1eFpoVE82UmhETTQ2Uk56?=
 =?utf-8?B?YyttV0R4TlJjdUc3a0o2SGZQdTNwN3BwYnQ1WHk5MEd4Nm1LWVFweGFHWmU0?=
 =?utf-8?B?cXp6Q2E1RmJQMUVWM3lIYldoeEQwbDlpTndIZkFGWmU3dXZ2SkNKNW1rTkhn?=
 =?utf-8?B?T0hYeC9uOUtudTV3a3dLdkpGVm0yc3NTSWp0MGNSMzhZVFhwaGdlSkRBbkpX?=
 =?utf-8?B?SmhrUUZ6NzcrS1I4Q2ZFYmJuWEluQW1DMWlqM1NETjh3YS94N2lwa1NKMEVM?=
 =?utf-8?Q?8k+XwaVzY36tlORecQ3lhxU=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7834dcb2-aa88-4145-7db1-08ddf4883a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 18:46:49.1322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fjMTO7enKLG5ePshCBp4So2BCFnmZVl0Jgpkd/kBxWaTQGY5Mt9IIZF85eSciy9Unn+0KeGJgnUN+M8z3Lg4NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4347
X-Proofpoint-ORIG-GUID: vIZKDh-J21dKy3z7lwKv8GyuXkvKrb8C
X-Authority-Analysis: v=2.4 cv=OPYn3TaB c=1 sm=1 tr=0 ts=68c85f1e cx=c_pps
 a=aLy/yOIiKxSZstcXcC3bSw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=mDV3o1hIAAAA:8 a=49XOPMxaPgPVv4gptbcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyMCBTYWx0ZWRfXxG1APcMNtAi3
 gPiBzBNd13inaRwPY8DObuVvYCmPdlNlnaBVzQ/ojEXtvK6zxtf1o7WB8BLN1qBFxIU0elHs34o
 4E3U1zN4p2d0ASJTGBNMSwKV813mLFNWmnzh6tzFFzMcX/lISJ+hTARWvUSAobIZz24oZokkT98
 HCR4kyBYFisyCtyamNZoq1LEVVUPX9f69tR4Oao8vpSffenRPg0gUsRdnArHkgq3aJCrOZ0Apgt
 NSwnF7nqwvGRDGlZ3DKn3O20diqBAV4dCTo5iMszv+dzFZ6M/8hGpxrudUa/J/VEb1iBghw8DQF
 SEs3q3yyieP2D2BvlyYsR7lPhtso/1Swrzv1jxj91aomkZyXGy3oEGtXQvs4mILjxm2SFmjwJZd
 GE7TmfcI
X-Proofpoint-GUID: 6Gz6lQiGOWhsGeMSKTuxFaw3j4Y20qWB
Content-Type: text/plain; charset="utf-8"
Content-ID: <90618F0BA9BEAB4D811634174DF1458A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [RFC] Fix potential undefined behavior in __builtin_clz usage
 with GCC 11.1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_07,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2509130020

On Mon, 2025-09-15 at 10:51 +0800, =E9=99=88=E5=8D=8E=E6=98=AD wrote:
> Hi all,
>=20
> I've identified several instances in the Linux kernel where __builtin_clz=
()
> is used without proper zero-value checking, which may trigger undefined
> behavior when compiled with GCC 11.1.0 using -march=3Dx86-64-v3 -O1 optim=
ization.
>=20
> PROBLEM DESCRIPTION:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> GCC bug 101175 (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D101175  ) =
causes
> __builtin_clz() to generate BSR instructions without proper zero handling=
 when
> compiled with specific optimization flags. The BSR instruction has undefi=
ned
> behavior when the source operand is zero, potentially causing incorrect r=
esults.
>=20
> The issue manifests when:
> - GCC version: 11.1.0 (potentially other versions)
> - Compilation flags: -march=3Dx86-64-v3 -O1
> - Code pattern: __builtin_clz(value) where value might be 0
>=20
> AFFECTED LOCATIONS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. HIGH RISK: net/ceph/crush/mapper.c:265
> Problem: __builtin_clz(x & 0x1FFFF) when (x & 0x1FFFF) could be 0
> Impact: CRUSH hash algorithm corruption in Ceph storage
>=20
> 2. HIGH RISK: drivers/scsi/elx/libefc_sli/sli4.h:3796
> Problem: __builtin_clz(mask) in sli_convert_mask_to_count() with no zero =
check
> Impact: Incorrect count calculations in SCSI operations
>=20
> 3. HIGH RISK: tools/testing/selftests/kvm/dirty_log_test.c:314
> Problem: Two __builtin_clz() calls without zero validation
> Impact: KVM selftest framework reliability
>=20
> 4. MEDIUM RISK: drivers/clk/clk-versaclock7.c:322
> Problem: __builtin_clzll(den) but prior checks likely prevent den=3D0
> Impact: Clock driver calculations (lower risk due to existing checks)
>=20
> COMPARISON WITH SAFE PATTERNS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> The kernel already implements safe patterns in many places:
>=20
> // Safe pattern from include/asm-generic/bitops/builtin-fls.h
> return x ? sizeof(x) * 8 - __builtin_clz(x) : 0;
>=20
> // Safe pattern from arch/powerpc/lib/sstep.c
> op->val =3D (val ? __builtin_clz(val) : 32);
>=20
> PROPOSED FIXES:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. net/ceph/crush/mapper.c:
> - int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> + u32 masked =3D x & 0x1FFFF;
> + int bits =3D masked ? __builtin_clz(masked) - 16 : 16;
>=20
> 2. drivers/scsi/elx/libefc_sli/sli4.h:
> if (method) {
> - count =3D 1 << (31 - __builtin_clz(mask));
> + count =3D mask ? 1 << (31 - __builtin_clz(mask)) : 0;
> count *=3D 16;
>=20
> 3. tools/testing/selftests/kvm/dirty_log_test.c:
> - limit =3D 1 << (31 - __builtin_clz(pages));
> - test_dirty_ring_count =3D 1 << (31 - __builtin_clz(test_dirty_ring_coun=
t));
> + limit =3D pages ? 1 << (31 - __builtin_clz(pages)) : 1;
> + test_dirty_ring_count =3D test_dirty_ring_count ?
> + 1 << (31 - __builtin_clz(test_dirty_ring_count)) : 1;
>=20
> REPRODUCTION:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Based on the GCC bug report and analysis of the kernel code patterns, this
> issue can be reproduced by:
>=20
> 1. Compiling affected code with: gcc -march=3Dx86-64-v3 -O1
> 2. Examining generated assembly for BSR instructions
> 3. Triggering code paths where the __builtin_clz argument could be zero
>=20
> QUESTIONS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. Should I prepare formal patches for each affected subsystem?

Yes, please, send the formal patch for Ceph case.

> 2. Are there other instances I should investigate?
> 3. Would adding a kernel-wide safe wrapper for __builtin_clz be appropria=
te?
> 4. Would the maintainers like me to create a proof-of-concept test case?

Yes, it will be great to have this proof-of-concept test case for Ceph case=
. I
am still trying to imagine a real use-case when we could have likewise issu=
e. I
believe it could be very useful to have some Kunit-based unit-test(s) for t=
his
subsystem in Ceph.

Thanks,
Slava.

