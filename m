Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E9740A17
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 09:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjF1H5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 03:57:45 -0400
Received: from outbound-ip7a.ess.barracuda.com ([209.222.82.174]:58966 "EHLO
        outbound-ip7a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231419AbjF1HzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 03:55:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108]) by mx-outbound-ea15-94.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 28 Jun 2023 07:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoMdz46ehLEsEusQRqidDoSR6Wy2gXJiu1/+e76Vwuor8pJ0/QRjkASvMhbg3OZIWWpHOzQn+aRFGAq3lgYqut3Pp4USIG5PzLQyglr+iRqYHI+NJjLokB3gdlxOF81zjLgGqDb41h8P8sa+sPDfUtjCmgjkwoMD+zu/3Izfhgb+G0H3+VcztNUgPtuJoGTDbBQ7rTZ+BDa0csRxd/qmmWRfeggr3U69shHBo1oFJValvFkK2+YiqFzSmUkkZy+HIK3n+3le97qUsPadTqbM8PnoEu8xxkGfk1TpbSOoFa6JqMtbk0g7nloazi1D6Cr6CfNFVFj5bJ7DdxXV7u+moQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wpkr5HQR/3UKw9Mrv3wM4ePxX7APx1l1v6UxLpgpJBo=;
 b=oRcYaXBBK8SPIP/G1TIP43F5GBilWa5WXeRpWzrT8KQMo5oF0qTlN9V5aacUzgrIWmqj89q1wWOEeWQN44Z4KDtY2Dakztnr+sg6z08Bot8J2Wkxuclah+JarMHTXhTPl3hFCgtOIvYieoAnAbPJKLQq7ce8WOalFmZCW60BqYpA3J5JJitONAUZA+yJ57zlXsMLlWD9rbS1qIcSnYUkXsNm2XwVUesmXVkufUAMkwFmVdyg+0GvDrwAiKxLv0PfTjlAZSG0QLANnJnKSGn7ld611SFpW/QeP0ckrR8C+37GBxe5Sk1Y7tnmP8oXp0YrtRcrbLkTkDqgQ4VOLv+5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wpkr5HQR/3UKw9Mrv3wM4ePxX7APx1l1v6UxLpgpJBo=;
 b=nvZ6CV3CRdv0FzgoJT09vXaDS3nfSuJPaGWhp7htdz9ZadeTRn8OxVeHHmww8DjVGNmPgU7VTXAMkchZ7cWa4Pfin6K4nENtdPyVvCJ8vKvSsGQcuhiMnPc+tZTQpS0wc/bCcBsr5o3tMY1vqnHDefi7MHX9jkuR63pHKJHO8/Y=
Received: from LV8PR19MB8249.namprd19.prod.outlook.com (2603:10b6:408:191::12)
 by CO6PR19MB5353.namprd19.prod.outlook.com (2603:10b6:303:144::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 06:19:52 +0000
Received: from LV8PR19MB8249.namprd19.prod.outlook.com
 ([fe80::a05d:58f5:99dc:75ef]) by LV8PR19MB8249.namprd19.prod.outlook.com
 ([fe80::a05d:58f5:99dc:75ef%4]) with mapi id 15.20.6500.045; Wed, 28 Jun 2023
 06:19:52 +0000
From:   Roman Bolshakov <rbolshakov@ddn.com>
To:     =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 01/16] MAINTAINERS: Update Roman Bolshakov email
 address
Thread-Topic: [PATCH v3 01/16] MAINTAINERS: Update Roman Bolshakov email
 address
Thread-Index: AQHZpsMheyi/SuGliUuOPtsU0HotzK+fw5cA
Date:   Wed, 28 Jun 2023 06:19:51 +0000
Message-ID: <c2fda5c9-56c6-8d8d-c3de-287c4f31b97c@ddn.com>
References: <20230624174121.11508-1-philmd@linaro.org>
 <20230624174121.11508-2-philmd@linaro.org>
In-Reply-To: <20230624174121.11508-2-philmd@linaro.org>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR19MB8249:EE_|CO6PR19MB5353:EE_
x-ms-office365-filtering-correlation-id: 363550ed-5cd1-490f-6c65-08db779faedc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OxR44FwCmEgoxDRsdH/NgqalO+BB/vao4G62Fuc8gDS+M1pdiBlIgJaZe6XrzWdOyUx2P8SEDI/0drTc4Z+BZ6TtAykS9QIYwREXNa8KbTvVnM2QODgO+jok80rlopvblukfy5LTQgvXYlfTC/8sEK4IqQwB1X287Y5XAJAQUSqVZ41mlEZFdKSaWi3VZ2LMjjlJhSRjs/fjNGTMuEIG+upmUOypl1fSEtmZE547FQJlE3mG+ywzc0Qpv0dwEsDD/rsyDQLSjppRlBVLWwRbV3yIoeIyfj4WM0gE8Wmkwk+rc0oqroHJf0D8MuctvCFjTW3ZazdcvTYV80TO8EngcLqT7eZ+Ex5QJ4LMJ15d+QlgKV8D348lQ+0k5Bv+PYecwhaZ7IFGuUeKMlqYBV8FuoSpJye8PKWyfboyBaORCY0n944eYflmnvX1fqP01MQh0rAJ6jii2yv9E7QCD1tyoBKuE35Ay6dMJLsltWYUY6Qd9Ms1PQzHgqjq7bQfCPHIHQWUz9rMi3SFw5f9XHeB21zgewuRLDsTQe5KepBbUX+OTFzydR/V3aUPmPSyy6LIooi+nTfJM7HSc3pnmQvoSLaKSVOJDDFv2qyWYTxPC30cqmP9AIerWF2B2MnqSFrOh4MsyqD3+6bMN1GVFogoZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR19MB8249.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(39850400004)(346002)(376002)(451199021)(6512007)(66446008)(31686004)(38070700005)(26005)(66556008)(66476007)(122000001)(5660300002)(7416002)(66574015)(86362001)(8936002)(41300700001)(4326008)(316002)(8676002)(66946007)(76116006)(64756008)(31696002)(38100700002)(110136005)(966005)(36756003)(6506007)(6486002)(186003)(2906002)(15650500001)(71200400001)(83380400001)(54906003)(2616005)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVNRcitVREYwbzBneEdlelhUT2JocXM5MG9nSWI1c0d6RnZ3SmR1c3ROSDEx?=
 =?utf-8?B?aFVIbTk4M0h6QTlXSCtOZVk5ZlZ4RTRrbDIzUkRpUXlZQ0F1L2R0RXZPaUNN?=
 =?utf-8?B?TXBjSlp3WFRUcmR5QmQ2OGJkZ1Q3akZxWVBuN0t4MnlQc0RrNXlLUm5vL2o5?=
 =?utf-8?B?Z3dJS3NjVGF6NVdxWVBtaGhxMjlaME4ydjlLTEtxZjMwMjU1SkpaWEVGNlhX?=
 =?utf-8?B?TG1WUmFab1N2K3NNUVBldVNTdWRTZDllU2c5Z2JWVGdzV1Q3eUNsWWY3cTZG?=
 =?utf-8?B?YWxwZ0xOUEgwYnJyVGxoWFBNOXZXZGJQaE5UNm93Zk9MYk5XZ2Q3dUFLZ2M1?=
 =?utf-8?B?V0R6bEx6bXE0TVhhWTR5N05IMVBlc25uSlpDVWZKb2pyOHdkT1NCOEdBanhw?=
 =?utf-8?B?WkhhTExCMktoRGVrRlVCMHNVYnRySFc2SWpteFl2MEZLVEVENzc4SjJGU2Fl?=
 =?utf-8?B?ODBHNlZtSlNGS1RVRDNJdjZrL05JUUlJTkdPNmJ4ZjF1OTVoSm1WbCtuaUYx?=
 =?utf-8?B?QndRRmFKUVUvVmRLREV6WFJ4T2xuQ2R2djM0bWNPL0JHL2ZZMjgwbGx3T3dH?=
 =?utf-8?B?NHJLbFNUUGpBV1psSEZLUm1OWjY0TnQzWTMwM1lMZWp1YStNUzc4QU9wci9y?=
 =?utf-8?B?Tlc2TW40QzNja01RWGduY0ovQmJwWndDdXNpdlBKdTZ0RnhYYm8rQzZBZU1u?=
 =?utf-8?B?M3VhamxOSWhtQnpLaVZVelAxbzNHeE9laTRHWlMrM2hRZGxiRGZCUFlCb1pJ?=
 =?utf-8?B?clVMa3NFSjF1c1ZZbE44NVJyL2sycDk0dnQ3QytMc3VkTHZybzRsTjNBa2Q3?=
 =?utf-8?B?Uk9WS05DeTFPdVpxTGZPbmNBS25KWVNML1FVSlpmZVFFMFg1YktkMHc4cG9X?=
 =?utf-8?B?d1NFMXlxNDUvY0Nyck90WnBmditLTmxUS1kxazdBQUNYNW9JVEhOS3o5R0s2?=
 =?utf-8?B?ZHNvSXJUWXdCWGVHYmdoODd2ZFlxMTR0TjdSdGI1eW9QQWE2eUszWHB6a09S?=
 =?utf-8?B?MDhId1ZBNzN6VWVNOFZVTXVKYUk0YVBRb0VqelFIL29NNDJrL0cwL1BHeTNw?=
 =?utf-8?B?NVNTUlJEWXZ1cUphdjRudEpudFI0R3l5MVI1RkdZTWJBZU9NQ042VG5MWGlh?=
 =?utf-8?B?SDJiaTdJRU1ObkZkQlQxSUVKOUl5alJxMjh1MGswMDRCTFZ3dVRmekJjZ0ND?=
 =?utf-8?B?Y1cwcUNXL1hkVEFxUzExdmwyV0d3bktRY0FDWVczVFdIdTFUUzNuZTBjV1dL?=
 =?utf-8?B?cGI1MGdtTUhwajN3Z3hiem81L0tJaFlkYVVtTlpkSGlXS1l5TVozUVFwTkxB?=
 =?utf-8?B?RTZJSW9McndqZXV2NHNjaFJWNk9zdTZyRi80YUphbW9Ja1hCMXN4R3VCTTlw?=
 =?utf-8?B?N3NyVHNiZ3FidGE4dERMbXNwS3JBN1hBdWozUHBZWSthaG85cWVUUTkvVXBW?=
 =?utf-8?B?QSszTDhGclFPR2NGd2dVZnk4L0MyQXpNRGRSNE5TTG92WTJjM3JlN0dPaDJH?=
 =?utf-8?B?VXlNeVVFc1NjcURpVmVLT2kwOUtONnlXcGpjUUZGSmM4dUhWYXlKdmZzb1Nq?=
 =?utf-8?B?QVpKSEV3eFFIWmtWd1BzMnEyZnBQZVdFQmpBdHNMdXVCRFpVVXVSdmtsVlZL?=
 =?utf-8?B?VkV2MTJYYmtKeGpTWEp5N29GT25od2lnckFnOE1Ic1cyRTJWb2EvaEpBQzdD?=
 =?utf-8?B?SzdMSFlWOG9rVjBaYnRrK1BuNVpvang1OERINVB0MXV2WTdXK000RDY1Zzdk?=
 =?utf-8?B?VE1jWmNvQzdCR214SHBrWU1wMFVpNUM0Y0tJNGpSUUNiWXpZaTlqeHV2aWhN?=
 =?utf-8?B?SmI0T3RXeE5zczdLM1FyY1lOSFRJUXBCVGZiS1RPTE9EVTZlUVo2M1daeEVT?=
 =?utf-8?B?OTVOWDZTamF2V0kzK05mVWRGQzkyejREbHkwR1VGb0NXaXhzZzNFU095TW5X?=
 =?utf-8?B?VjNJZ0hVSE5LeDhZZDRvRm51cUhBQ1F6eVFsc3E2bHB4bFYwRVhHNjhZOFB4?=
 =?utf-8?B?MkNmZTlRMzZ3WC9uTy9wTTdYOVdJWllYNFkxdi8zVFNSc3VyM2JQVkp2Q0R4?=
 =?utf-8?B?MlBFemZzOUIyL3hRN1E3ajVBWHNsZEYxdHdNeU5XU0NhMjNGMlJMR3JHSUJK?=
 =?utf-8?Q?ovVI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D14D5FFAF0F0C64EBAD1047B4DD3516A@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dEpOWkR4ZGxtdVpoVTlXNjUxQzE5Q1dycUpyQ3pPWHNjc01NRllIa25LZ2Fq?=
 =?utf-8?B?K3kyMk1zazR2di8vVE84enZuTXl5cVBtOTROeDM0aUUrZGRqcnNyVzFzWmVP?=
 =?utf-8?B?eE9mS3czMmJzVU55ZGkzYVZNYTlIWXFzRkVKRXIvZHFwSzBDVGN4SjlxWGpV?=
 =?utf-8?B?K2lKU1Bmc3ZBdjg0ZDhXVWFmMDBDTkQ5ZDJmdWZhbnZrTUVtblNaWFVxNG1q?=
 =?utf-8?B?VzF2bmg0V3U5SURUOFd4cUJpSXVRZFQ2d3RwV2RZR2daYXdrWk50Ty8rU2Nm?=
 =?utf-8?B?UHY3SnNDRHJ5aHFrdElqTC84bTYvLzR6TWpvV01yL21VRUtLRThhZXRsaUV4?=
 =?utf-8?B?clBuTmJLdndQT1lPL29ISFhXamxiN2pDbWY4aEd4QWpTS2tTQWJybnZGbG94?=
 =?utf-8?B?aENBVTdQbXJlQXBJdmRWME8wcHpxRnZtT1ZFU0NNVWZJMHgvZTJzS2lxdlZ1?=
 =?utf-8?B?ZkJwNTJZMm84NnZXakdEcm5PSFNReVkxMHJxQlVLTnl1T0h6cVdENFd1dEdM?=
 =?utf-8?B?THJNR3A0M2ZtME1qeXhncG1HU3VOV054NHlGZW5BdEp2b0xsTTg3SmVoREZx?=
 =?utf-8?B?WmdYOWJPTGRTVVZJWEMreWdSMnBWQkoxODdHay90YURaV0d4ZjdPQnZnWlRj?=
 =?utf-8?B?YXhOZnNXUUg5cjRPWU9pSmtvVGVYYzFNazBIRDlUL1p6a2xBMGNvdGFoY2Ni?=
 =?utf-8?B?ZWxMRHc1NDdwWnRqcEJXb3BDeGxxbC9WWFI0SCtIVSt5SFBNUStmZXJMNXNP?=
 =?utf-8?B?SU5wSHRCc29IYlU0NTEvMmZyRmxrR21LTWtUQjJtTFVPeXl4R1FuWG1HZUxh?=
 =?utf-8?B?SGthcEp4WlBjZXlOV1FHYUlWam9hZk1NYjh4bEVhM3NadmxTWnNWM2VxYnNi?=
 =?utf-8?B?OVJ2NVVhdG8xVGRVMU9kU0UxQ1V6VGw4bWZVUmNtSkJvWHRiRzRlb2RSN1NN?=
 =?utf-8?B?bmQzOUdja3k1RlhDcCthNE4yOENPbEhQazJyZDBtSGNDMm50bENmdnlGMVdM?=
 =?utf-8?B?MW82VC9USHJuMzZXYnJwaHdxdmlQL25OemxuNnY1OXpwM2JWQnlOT1dkdGlQ?=
 =?utf-8?B?b2Z2eGZGcFltWDh0TEFXYlVQVVpwMkhNSnFBcEJCZ1JNVlkvUll0THVoRUF5?=
 =?utf-8?B?eGxBRWt1eTdIbEJwZGZsbURsdGdrUW5TdHBhZEE1L0VEOGZmcFZZZHFpblRo?=
 =?utf-8?B?UnE5eFQ2ZnZGb2t6TDMwZXBZWFRhLzZBbUpqVTVsQUJVYWNyaGF5dnlMNVRY?=
 =?utf-8?B?c05vMnRVYkdTZmlmck55UEdsRE9ReXNkUzloL1ppdXF5SVIvV1MrNC95NWpo?=
 =?utf-8?B?Qy9md3Y0OWQ3dWlsNjA2TGxRT09YVnI5N2kwSU5Xbno4Z3ZjUjB6aWx1SytT?=
 =?utf-8?B?TDREVUNiR1I4RXZQTHF3QnhWZkZWWmJuNEd2Skl3WEIxR2NibjQ4a0tJS0Jl?=
 =?utf-8?B?cnJHRnpXdHUzMXFJN3BJd1FQaXcrWGcrZ25HZnlod0dzOUlibFF0TCtoOG1X?=
 =?utf-8?B?cFgrV0lRMlpCNlpGREN4cW5EaStHNzFwWXROeFRaT1BuYUFTRlRzMEpQYkl4?=
 =?utf-8?B?Tjg5WjVHVmNodmpDVnd6aVJybmxWMFFwSGZZeTFvQlcxdXg0S1V4bGZ2TlRu?=
 =?utf-8?Q?fnNWRgVBGcTsqP3Et6w94esh1XXYp2IEiBfVG1eylizk=3D?=
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR19MB8249.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 363550ed-5cd1-490f-6c65-08db779faedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 06:19:51.9759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: txC4pu41dSOMYjTTPu/qICBOQjD5uW9hn4P8EKJ3TvNtIWtgc9OV71094kj45jtcMXrwVzECiMpc4uWp4bfQ5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB5353
X-BESS-ID: 1687938910-103934-7346-2021-1
X-BESS-VER: 2019.3_20230620.2124
X-BESS-Apparent-Source-IP: 104.47.58.108
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYGRoZAVgZQ0MAwJckyKSXJNC
        nZzMzCwsIsJdHIwCIx2cg4KSUxzcJYqTYWADYob8lBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.249134 [from 
        cloudscan14-0.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.50 BSF_RULE7568M          META: Custom Rule 7568M 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_RULE7568M
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MjQuMDYuMjAyMyAyMDo0MSwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kg0L/QuNGI0LXRgjoNCj4g
ci5ib2xzaGFrb3ZAeWFkcm8uY29tIGlzIGJvdW5jaW5nOiBVcGRhdGUgUm9tYW4ncyBlbWFpbCBh
ZGRyZXNzDQo+IHVzaW5nIG9uZSBmb3VuZCBzb21ld2hlcmUgb24gdGhlIEludGVybmV0OyB0aGlz
IHdheSBoZSBjYW4gQWNrLWJ5Lg0KPg0KPiAoUmVvcmRlciBUYXlsb3IncyBsaW5lIHRvIGtlZXAg
dGhlIHNlY3Rpb24gc29ydGVkIGFscGhhYmV0aWNhbGx5KS4NCj4NCj4gU2lnbmVkLW9mZi1ieTog
UGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0KPiAtLS0NCj4gICBN
QUlOVEFJTkVSUyB8IDQgKystLQ0KPiAgIC5tYWlsbWFwICAgIHwgMyArKy0NCj4gICAyIGZpbGVz
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdp
dCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMNCj4gaW5kZXggN2YzMjNjZDJlYi4uMWRhMTM1
YjBjOCAxMDA2NDQNCj4gLS0tIGEvTUFJTlRBSU5FUlMNCj4gKysrIGIvTUFJTlRBSU5FUlMNCj4g
QEAgLTQ5NywxNCArNDk3LDE0IEBAIEY6IHRhcmdldC9hcm0vaHZmLw0KPiAgIA0KPiAgIFg4NiBI
VkYgQ1BVcw0KPiAgIE06IENhbWVyb24gRXNmYWhhbmkgPGRpcnR5QGFwcGxlLmNvbT4NCj4gLU06
IFJvbWFuIEJvbHNoYWtvdiA8ci5ib2xzaGFrb3ZAeWFkcm8uY29tPg0KPiArTTogUm9tYW4gQm9s
c2hha292IDxyYm9sc2hha292QGRkbi5jb20+DQo+ICAgVzogaHR0cHM6Ly93aWtpLnFlbXUub3Jn
L0ZlYXR1cmVzL0hWRg0KPiAgIFM6IE1haW50YWluZWQNCj4gICBGOiB0YXJnZXQvaTM4Ni9odmYv
DQo+ICAgDQo+ICAgSFZGDQo+ICAgTTogQ2FtZXJvbiBFc2ZhaGFuaSA8ZGlydHlAYXBwbGUuY29t
Pg0KPiAtTTogUm9tYW4gQm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+DQo+ICtNOiBS
b21hbiBCb2xzaGFrb3YgPHJib2xzaGFrb3ZAZGRuLmNvbT4NCj4gICBXOiBodHRwczovL3dpa2ku
cWVtdS5vcmcvRmVhdHVyZXMvSFZGDQo+ICAgUzogTWFpbnRhaW5lZA0KPiAgIEY6IGFjY2VsL2h2
Zi8NCj4gZGlmZiAtLWdpdCBhLy5tYWlsbWFwIGIvLm1haWxtYXANCj4gaW5kZXggYjU3ZGE0ODI3
ZS4uNjRlZjlmNGRlNiAxMDA2NDQNCj4gLS0tIGEvLm1haWxtYXANCj4gKysrIGIvLm1haWxtYXAN
Cj4gQEAgLTc2LDkgKzc2LDEwIEBAIFBhdWwgQnVydG9uIDxwYXVsYnVydG9uQGtlcm5lbC5vcmc+
IDxwYnVydG9uQHdhdmVjb21wLmNvbT4NCj4gICBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhp
bG1kQGxpbmFyby5vcmc+IDxmNGJ1Z0BhbXNhdC5vcmc+DQo+ICAgUGhpbGlwcGUgTWF0aGlldS1E
YXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPiA8cGhpbG1kQHJlZGhhdC5jb20+DQo+ICAgUGhpbGlw
cGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPiA8cGhpbG1kQGZ1bmdpYmxlLmNv
bT4NCj4gK1JvbWFuIEJvbHNoYWtvdiA8cmJvbHNoYWtvdkBkZG4uY29tPiA8ci5ib2xzaGFrb3ZA
eWFkcm8uY29tPg0KPiAgIFN0ZWZhbiBCcmFua292aWMgPHN0ZWZhbi5icmFua292aWNAc3lybWlh
LmNvbT4gPHN0ZWZhbi5icmFua292aWNAcnQtcmsuY29tLmNvbT4NCj4gLVlvbmdib2sgS2ltIDx5
b25nYm9rLmtpbUBtaXBzLmNvbT4gPHlvbmdib2sua2ltQGltZ3RlYy5jb20+DQo+ICAgVGF5bG9y
IFNpbXBzb24gPGx0YXlsb3JzaW1wc29uQGdtYWlsLmNvbT4gPHRzaW1wc29uQHF1aWNpbmMuY29t
Pg0KPiArWW9uZ2JvayBLaW0gPHlvbmdib2sua2ltQG1pcHMuY29tPiA8eW9uZ2Jvay5raW1AaW1n
dGVjLmNvbT4NCj4gICANCj4gICAjIEFsc28gbGlzdCBwcmVmZXJyZWQgbmFtZSBmb3JtcyB3aGVy
ZSBwZW9wbGUgaGF2ZSBjaGFuZ2VkIHRoZWlyDQo+ICAgIyBnaXQgYXV0aG9yIGNvbmZpZywgb3Ig
aGFkIHV0ZjgvbGF0aW4xIGVuY29kaW5nIGlzc3Vlcy4NCg0KSGkgUGhpbGlwcGUsDQoNClJldmll
d2VkLWJ5OiBSb21hbiBCb2xzaGFrb3YgPHJib2xzaGFrb3ZAZGRuLmNvbT4NCg0KVGhhbmtzIGZv
ciB1cGRhdGluZyB0aGUgZW1haWwuDQoNCg==
