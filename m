Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B962525662
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358376AbiELUc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiELUcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:32:24 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C246D3BB;
        Thu, 12 May 2022 13:32:22 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFFh8R030322;
        Thu, 12 May 2022 13:31:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=pOpWcraONMJ9/rO9VUca+twq74KxkNTjqVmIUnkerfk=;
 b=chiHdPJeLVEr7uUQo7EvR0hE5AWiui4iRqVMNUqMxBcStS97+CjknQoP6s/Us+OzjKv7
 MAjKra48nFstyCQnlQ7IDPVL7GzqsVE7KowFeJw99iKL4qmYQIcJNs7jZmVFBENLSJze
 uHy8DY7HykJZSA/smY5JA2wNSj6XiO/iA+MUexxXsY78wCygxIzxcLXg/37m1kzx7Ung
 DQyOPQTr5/Z6RoFRhV3KyuAGBmocOU/XdF4leEB25iw93UmG+/AjBeCOiWWPgd+ugpv7
 AwGd2pz5O80/mXZIzoqj68mi15vomOKgRv84U6s9q5qABUlNnF3iRS1cSYOBpDC4Hkz/ +w== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwqufuse4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3UYaVSL/mmAKJ7vnvwURNLzlAgeFuHauTunlyxrsVRWnYRIKsWOOPAo0OZKrvVa2+vCapc11aJiYwZc/M6qyZmkO7VgH3tXgVDbLXzEiDxEzYPXuwahTOTA+guE2r2eZfbKm+tflH+5oU9LxGXuSo/2G3HOuNKp+vz9DrRCD9GpCLRkmh0QHYvxggidPr0tS3fus3Abq0XzSbSu2r6HmBUfhW+qJTFtOm1S3R5EX94nB5uVqOP5rzPEbG7VS+uINPo9YabbY4+Dk76tT1dHOFYXhHDngWjv1Wzk9pDqAdMDX+5UQxFzZK8Bo/ULcMfhdL2u9OY2UR2QczXx//bxeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOpWcraONMJ9/rO9VUca+twq74KxkNTjqVmIUnkerfk=;
 b=YX9Ax23GjablKkZH/zyuEhOikjnnszBBZZ+KcnIBctNgEANQ7FPPDWrTLUwUrzf3jHZMIPB61CZEsaszub4hHf8NU4JFHYf/jUlZj4fzfica/P9PIqlXbMsvajquJBtX2HP/5WMFNgidYwEf4Ovq9rT46xBmAKYO8fS6RvKaDoT7Y94FMgxMl1eifIdXjegRq7eJ61TB8rbHeyNh8wtuVVT5T5rE+opE+BB5vIlulGRHf9FVhTfeLk9Hyn82sCZPI1cwA68t0N9pwc7E0P+w50hNfqULHhYlBYhuUn0qbCWYw2p9xPkB9IvAI6C5GEX61VMIh11nEBOWLRStOynYaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB3828.namprd02.prod.outlook.com (2603:10b6:207:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 20:31:27 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 20:31:27 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Thread-Topic: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Thread-Index: AQHYZjCCNu0C0Uz/6UepE20RTbQUAK0boCkAgAACRQCAAARvAIAABIOAgAAGvoA=
Date:   Thu, 12 May 2022 20:31:27 +0000
Message-ID: <C85C63A5-D5F5-4E5D-B516-BD27FC56D06D@nutanix.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com> <Yn1hdHgMVuni/GEx@google.com>
 <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com>
In-Reply-To: <Yn1o9ZfsQutXXdQS@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14f3f85a-00e7-4ea3-0dec-08da345663ba
x-ms-traffictypediagnostic: BL0PR02MB3828:EE_
x-microsoft-antispam-prvs: <BL0PR02MB3828FC23ED7D4C34F8DF6AA7AFCB9@BL0PR02MB3828.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2nNilipBIcvtJT9h8LmIuuUPiyoe3X5CAY2+EHw3LkBiG4wGIwJPXbj2utLgKgoKYaMOsntBOJXmN+aCmV0r99uTD8foPGZDXc2X/pstD6PKQwvF5XEwBQqb5f9NJhV2s6HtaPTJodonzF5CJa9cejgdQ87TcMFfkMN31UO3lKXeA311pzH7d23uraZaGLrabZ79DOCDx6zecYdb08PDcsfqVWOs/o44+5NfUmsUfdlyitPsyFuViORfNaWfqk9AThNu7dMgXhBM9UnpS78WrDr9qvNrFOd5I0OLK3BwK7L/e2h6A4S9KZvOBz+E/JHVzjC4AbLvXMjvYCKzkU12hbDUrKdQE4/g2t/iD0lzXM9o/Yz6rJ8lDZSbMrbMUdsJS00quCkD0CMOiVFAyZjscAjlN03ghDkEh1DufuN5x/o0pYMUS1Ks+rZeVDKVVDP8T8/ocAMYrStLf65gJ3GF78Cm0k6yjO3+8zT3194DlDUtY9v3tg+lCJUGx5Zos3a12wtdFkW83l8BjHXs6aZSG37owp01BWlCuJHq7DL74m0z1aURfc9vkoO6Zu5r7/l0fyJvbHectt3hLTrrtBtDFumdUzhLCakpJC4Eb018oRojr5Ds10M9xnaIQws868bZg9pxN+3djyoG3hux97wzN8w6zSzPEDMKMsvzEhIYpKEHhF591Sq+kkXFU6DwKBdzfo1TCdalnb/2kSzxYKiYwSiAKfmmselIqlpEoGvdEISL2OqC2bcM4mQ+Aw2/Nrx2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(508600001)(316002)(33656002)(6486002)(6512007)(186003)(86362001)(6506007)(2906002)(5660300002)(7416002)(122000001)(83380400001)(2616005)(36756003)(91956017)(53546011)(8676002)(64756008)(4326008)(76116006)(66476007)(66446008)(54906003)(66946007)(66556008)(6916009)(38100700002)(38070700005)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXh2MVM4MVN6ODdoRmFnL2g5Rys1dk9CR2IwZ0NOeWRLUFhCSzIzTnVXd3o1?=
 =?utf-8?B?QzJrYVNzSWMrNG4wc2hOUjYwRnVCcHVNM2lHMDgvbVJIWS9mOWlGM3pTSFVv?=
 =?utf-8?B?UzB4U29rUUpRcEZjbC9sV0c3Ti9nU2ZPMFRicW5VaGMwNVIzKytVcEQ0VlZv?=
 =?utf-8?B?YmJhY2wxdXBFUFAwNHlEcnRIQm5RZTlhV01RMkYxNXJVMVJDK1F2OUh3Q2V6?=
 =?utf-8?B?Z0w4RU1nckM0S0NCQzFMY3BwdzdzVEIvdHNkZUpWV09tcHJ6b2ZuNzkxMjEz?=
 =?utf-8?B?eUxIUHdkUjd5OHg3eVJKaDI2R2ZhcWQ2TW1ZUHJ5S1IrMElBOGlRakNFNW42?=
 =?utf-8?B?ZmlLODZzdlhBd3JpSDM1V0Y5OVVGOGo3ZnRtdzdxL09wNDZIQ0VEd2FvOW4v?=
 =?utf-8?B?a2liSGpwY2FsMG01Ri9iKytlSWt3S0I4enJXNTNDTlA0SnArWE1mNjU0Mys5?=
 =?utf-8?B?SVZvbkFoaDNUdmxTK1ZiOFJleWZ4ZWFkSnkrZ3FJajdBV08zbnZwVW5idnFn?=
 =?utf-8?B?UElpK3V3aFd2SXE2WDFPYjh2KzJtaEVjUFlieVVFYm8zUU5wQWdhK2FHVWdk?=
 =?utf-8?B?VVkvWG04Zy9HeUhwS1NMWnRQZGl3UXAzbHJFYVFmdE53bG9aOXYzTW5OZVdC?=
 =?utf-8?B?WUZCOUVtWnd5b012UENDUG44SExIOGR2V3d5YTVSSEhldUs0eDRGU0VQWW9E?=
 =?utf-8?B?c25ZYjcyWWlZbUI5MnRTRGxrb0QvcmcwLzBVZ1Y0RGdqYnBzeTkySlJtM3N2?=
 =?utf-8?B?UWJzQnZCeUJHeHc3YWwxK0ZlZU9oL3FGSDdFbll2Z1VOeDNmaW5QSnp3MFVE?=
 =?utf-8?B?ajh3WGg0RUJYbnRuY2xHYzdpQnh4aGJwWXVmR091MkllZHFwWVJOc2VGSTkx?=
 =?utf-8?B?M2llUHM2dWIzbWlCTVdIRzdNSUR2ZmtnMnZud2pzRGJqNWc3WGtObERFVzFN?=
 =?utf-8?B?Zm4vNGZXdlZQamVRWS8zNnhGbHlBOGNpajIxZ2xMeDBFWHdpK3k5MWdOdjJh?=
 =?utf-8?B?UlBxeElUUFZYMUphWFlRQjZtTE0wdkFOYTRwK1ZaUFZYTXo4NmdYQzhHVndZ?=
 =?utf-8?B?aHorNGpsbVlpaGljMDFoNXU4OWIxaU9DakVOcHhQMmxJUDhENmV1MmhjSFRJ?=
 =?utf-8?B?L3BQaXlVR2ZzRmJZaXQzUEsyTmFuT2NkTXJkbndmdm01cnkzdEVGMDJkZWVR?=
 =?utf-8?B?bnZ1REkxZjlHVHY3dWpwUVN0RGN1bkNUcGx5T0hGN1ZoRTVibUlCRTFlU0FX?=
 =?utf-8?B?NHpBeVloNkxvOExlUnBTcUtjZThCb0ZQUGxYdVM4bm12enlOd3VYQVBGM1FF?=
 =?utf-8?B?My95SWNreWszTkNYSTFldjQ3SkJlVmxQM3UwN3dXOE1iSjFSSmI2ZlJoczlz?=
 =?utf-8?B?ZWFSWFFOVnFjWnhGclIzODNVRUV6aHJlb0dTTkhHaUNYQ3hmNmpXUkxCdUxn?=
 =?utf-8?B?Z3RWUEc2T1lwMFpIeVFGSmpwN2NDQ3B1OEg1QUZMK3AzK3pmZnRvUktwNjlv?=
 =?utf-8?B?eGY1MWZUUmhkZFZ4NEw4N1dlU01yQVkrZWVrQW9EUWp3MnhQYTVxRkN4bUl0?=
 =?utf-8?B?bDB5NnhNTXQrQW1sN3B0MUhqQ2ZrLzhaTlhRK0VheDZVNU9rRHlWTTFiOW1a?=
 =?utf-8?B?aHRBSkRTVFFZMFdEUGZqMllDa3A1Q0N6N1NQU0IwLzhYWHlpUHB3cEcrbmdZ?=
 =?utf-8?B?UkJCVkw1bzNJOElrdysrUTBMWDZYYTBNc1duV1F5dUtEemN1bW5yTjRtaGxH?=
 =?utf-8?B?ZVY4U2VtUnhpQ2srL2tLUU9HdWYzbnpqcmRzY1R0N3RkZ0pNaERSK0ZLdHpi?=
 =?utf-8?B?blowOWZ3QlljVGRtUnUzWnR4eDhoVjZYQjZQSWtxNXd2V0Q3NU14QW15bEdq?=
 =?utf-8?B?SlZaOVVVc3FDK2Z1U1NIZnFCeVQ1cm9adnZNL1ZwbGVoYTJEdkw0OTN0ekcr?=
 =?utf-8?B?YjZHTmZjdmxQNnFZSlhVclRKQVNrUS96dyt2eXIzbWUvR3h3TjVLVnRIdFQv?=
 =?utf-8?B?bE9pR0xhQVkwbzZ4WGU4T0NKQ3ROZzlYa3dSTjdvdmlhT3hBdkpQQml1WVNq?=
 =?utf-8?B?Ry9pTkxIVGZudnVjL0dudWl0REpHS2I1SkVRNlAvRi83b3RpTDZZb0xFdG5M?=
 =?utf-8?B?M050K0x3N24yeHRQSDhqVVQzZVZOakQ5YXdHNGkyeFVqLys0RWorRDVQUFRR?=
 =?utf-8?B?SFhyWjZVSkhzd3RJcGNuWEI4WlFZZzlXZXdja1cvcy90eHgwLzg4RGZwMk10?=
 =?utf-8?B?b2kwV1ZIRVpsTmgwcEtaUkVsM2U1QUppbWdMdDdDQzVnbWFRYURYVGxRWTRD?=
 =?utf-8?B?YldoN3c5VVQyTEJLM1VBWXFhTnFmSFYwUjdTQkQwL0JaVVlheTBqQmE5eWlx?=
 =?utf-8?Q?U47mulmCmXkQadPTt17Z926JsgZyoq7FAae4qRm1bgdmm?=
x-ms-exchange-antispam-messagedata-1: w+cVhr3xh+2+XyOXegSzrnC7H4QHOtpatljTRfwqhFuvG6zF4MdmqNxl
Content-Type: text/plain; charset="utf-8"
Content-ID: <331BAA708AADB743A5CC6F59A951BD04@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f3f85a-00e7-4ea3-0dec-08da345663ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 20:31:27.0690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bxOztRxGcNAtqsTV1D3gbl+upsao11JGXWULlPDakql+q0H0SY+wliMNLCem7ZIJ/KVvCL10qRVVCCMJukAL7ej1Mcyv1DPg6c/76Mm93DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3828
X-Proofpoint-GUID: cHkX6laIZOA-l_SDJvIm7qw28tYi9lR8
X-Proofpoint-ORIG-GUID: cHkX6laIZOA-l_SDJvIm7qw28tYi9lR8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_17,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCA0OjA3IFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIE1heSAxMiwgMjAyMiwgSm9u
IEtvaGxlciB3cm90ZToNCj4+IA0KPj4gDQo+Pj4gT24gTWF5IDEyLCAyMDIyLCBhdCAzOjM1IFBN
LCBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+
Pj4gT24gVGh1LCBNYXkgMTIsIDIwMjIsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+Pj4+
IE9uIFRodSwgTWF5IDEyLCAyMDIyLCBKb24gS29obGVyIHdyb3RlOg0KPj4+Pj4gUmVtb3ZlIElC
UEIgdGhhdCBpcyBkb25lIG9uIEtWTSB2Q1BVIGxvYWQsIGFzIHRoZSBndWVzdC10by1ndWVzdA0K
Pj4+Pj4gYXR0YWNrIHN1cmZhY2UgaXMgYWxyZWFkeSBjb3ZlcmVkIGJ5IHN3aXRjaF9tbV9pcnFz
X29mZigpIC0+DQo+Pj4+PiBjb25kX21pdGlnYXRpb24oKS4NCj4+Pj4+IA0KPj4+Pj4gVGhlIG9y
aWdpbmFsIGNvbW1pdCAxNWQ0NTA3MTUyM2QgKCJLVk0veDg2OiBBZGQgSUJQQiBzdXBwb3J0Iikg
d2FzIHNpbXBseQ0KPj4+Pj4gd3JvbmcgaW4gaXRzIGd1ZXN0LXRvLWd1ZXN0IGRlc2lnbiBpbnRl
bnRpb24uIFRoZXJlIGFyZSB0aHJlZSBzY2VuYXJpb3MNCj4+Pj4+IGF0IHBsYXkgaGVyZToNCj4+
Pj4gDQo+Pj4+IEppbSBwb2ludGVkIG9mZmxpbmUgdGhhdCB0aGVyZSdzIGEgY2FzZSB3ZSBkaWRu
J3QgY29uc2lkZXIuICBXaGVuIHN3aXRjaGluZyBiZXR3ZWVuDQo+Pj4+IHZDUFVzIGluIHRoZSBz
YW1lIFZNLCBhbiBJQlBCIG1heSBiZSB3YXJyYW50ZWQgYXMgdGhlIHRhc2tzIGluIHRoZSBWTSBt
YXkgYmUgaW4NCj4+Pj4gZGlmZmVyZW50IHNlY3VyaXR5IGRvbWFpbnMuICBFLmcuIHRoZSBndWVz
dCB3aWxsIG5vdCBnZXQgYSBub3RpZmljYXRpb24gdGhhdCB2Q1BVMCBpcw0KPj4+PiBiZWluZyBz
d2FwcGVkIG91dCBmb3IgdkNQVTEgb24gYSBzaW5nbGUgcENQVS4NCj4+Pj4gDQo+Pj4+IFNvLCBz
YWRseSwgYWZ0ZXIgYWxsIHRoYXQsIEkgdGhpbmsgdGhlIElCUEIgbmVlZHMgdG8gc3RheS4gIEJ1
dCB0aGUgZG9jdW1lbnRhdGlvbg0KPj4+PiBtb3N0IGRlZmluaXRlbHkgbmVlZHMgdG8gYmUgdXBk
YXRlZC4NCj4+Pj4gDQo+Pj4+IEEgcGVyLVZNIGNhcGFiaWxpdHkgdG8gc2tpcCB0aGUgSUJQQiBt
YXkgYmUgd2FycmFudGVkLCBlLmcuIGZvciBjb250YWluZXItbGlrZQ0KPj4+PiB1c2UgY2FzZXMg
d2hlcmUgYSBzaW5nbGUgVk0gaXMgcnVubmluZyBhIHNpbmdsZSB3b3JrbG9hZC4NCj4+PiANCj4+
PiBBaCwgYWN0dWFsbHksIHRoZSBJQlBCIGNhbiBiZSBza2lwcGVkIGlmIHRoZSB2Q1BVcyBoYXZl
IGRpZmZlcmVudCBtbV9zdHJ1Y3RzLA0KPj4+IGJlY2F1c2UgdGhlbiB0aGUgSUJQQiBpcyBmdWxs
eSByZWR1bmRhbnQgd2l0aCByZXNwZWN0IHRvIGFueSBJQlBCIHBlcmZvcm1lZCBieQ0KPj4+IHN3
aXRjaF9tbV9pcnFzX29mZigpLiAgSHJtLCB0aG91Z2ggaXQgbWlnaHQgbmVlZCBhIEtWTSBvciBw
ZXItVk0ga25vYiwgZS5nLiBqdXN0DQo+Pj4gYmVjYXVzZSB0aGUgVk1NIGRvZXNuJ3Qgd2FudCBJ
QlBCIGRvZXNuJ3QgbWVhbiB0aGUgZ3Vlc3QgZG9lc24ndCB3YW50IElCUEIuDQo+Pj4gDQo+Pj4g
VGhhdCB3b3VsZCBhbHNvIHNpZGVzdGVwIHRoZSBsYXJnZWx5IHRoZW9yZXRpY2FsIHF1ZXN0aW9u
IG9mIHdoZXRoZXIgdkNQVXMgZnJvbQ0KPj4+IGRpZmZlcmVudCBWTXMgYnV0IHRoZSBzYW1lIGFk
ZHJlc3Mgc3BhY2UgYXJlIGluIHRoZSBzYW1lIHNlY3VyaXR5IGRvbWFpbi4gIEl0IGRvZXNuJ3QN
Cj4+PiBtYXR0ZXIsIGJlY2F1c2UgZXZlbiBpZiB0aGV5IGFyZSBpbiB0aGUgc2FtZSBkb21haW4s
IEtWTSBzdGlsbCBuZWVkcyB0byBkbyBJQlBCLg0KPj4gDQo+PiBTbyBzaG91bGQgd2UgZ28gYmFj
ayB0byB0aGUgZWFybGllciBhcHByb2FjaCB3aGVyZSB3ZSBoYXZlIGl0IGJlIG9ubHkgDQo+PiBJ
QlBCIG9uIGFsd2F5c19pYnBiPyBPciB3aGF0Pw0KPj4gDQo+PiBBdCBtaW5pbXVtLCB3ZSBuZWVk
IHRvIGZpeCB0aGUgdW5pbGF0ZXJhbC1uZXNzIG9mIGFsbCBvZiB0aGlzIDopIHNpbmNlIHdl4oCZ
cmUNCj4+IElCUELigJlpbmcgZXZlbiB3aGVuIHRoZSB1c2VyIGRpZCBub3QgZXhwbGljaXRseSB0
ZWxsIHVzIHRvLg0KPiANCj4gSSB0aGluayB3ZSBuZWVkIHNlcGFyYXRlIGNvbnRyb2xzIGZvciB0
aGUgZ3Vlc3QuICBFLmcuIGlmIHRoZSB1c2Vyc3BhY2UgVk1NIGlzDQo+IHN1ZmZpY2llbnRseSBo
YXJkZW5lZCB0aGVuIGl0IGNhbiBydW4gd2l0aG91dCAiZG8gSUJQQiIgZmxhZywgYnV0IHRoYXQg
ZG9lc24ndA0KPiBtZWFuIHRoYXQgdGhlIGVudGlyZSBndWVzdCBpdCdzIHJ1bm5pbmcgaXMgc3Vm
ZmljaWVudGx5IGhhcmRlbmVkLg0KDQpXaGF0IGlmIHdlIGtleWVkIG9mZiBNU1IgYml0bWFwLCBz
dWNoIHRoYXQgaWYgYSBndWVzdCAqZXZlciogaXNzdWVkIElCUEIsIEtWTQ0KY2FuIGRvIElCUEIg
b24gc3dpdGNoPyBXZSBhbHJlYWR5IGRpc2FibGUgaW50ZXJjZXB0aW9uIHRvZGF5LCBzbyB3ZSBo
YXZlIHRoZQ0KZGF0YSwganVzdCBsaWtlIHdlIGRvIGZvciBTUEVDX0NUUkwuDQoNCiAgICBpZiAo
cHJldiAhPSB2bXgtPmxvYWRlZF92bWNzLT52bWNzKSB7DQogICAgICAgIHBlcl9jcHUoY3VycmVu
dF92bWNzLCBjcHUpID0gdm14LT5sb2FkZWRfdm1jcy0+dm1jczsNCiAgICAgICAgdm1jc19sb2Fk
KHZteC0+bG9hZGVkX3ZtY3MtPnZtY3MpOw0KDQogICAgICAgIC8qDQogICAgICAgICAqIE5vIGlu
ZGlyZWN0IGJyYW5jaCBwcmVkaWN0aW9uIGJhcnJpZXIgbmVlZGVkIHdoZW4gc3dpdGNoaW5nDQog
ICAgICAgICAqIHRoZSBhY3RpdmUgVk1DUyB3aXRoaW4gYSBndWVzdCwgZS5nLiBvbiBuZXN0ZWQg
Vk0tRW50ZXIuDQogICAgICAgICAqIFRoZSBMMSBWTU0gY2FuIHByb3RlY3QgaXRzZWxmIHdpdGgg
cmV0cG9saW5lcywgSUJQQiBvciBJQlJTLg0KICAgICAgICAgKiBXZSdsbCBvbmx5IGlzc3VlIHRo
aXMgSUJQQiBpZiB0aGUgZ3Vlc3QgaXRzZWxmIGhhcyBldmVyIGlzc3VlZA0KICAgICAgICAgKiBh
biBJQlBCLCB3aGljaCB3b3VsZCBpbmRpY2F0ZSB0aGV5IGNhcmUgYWJvdXQgcHJlZGljdGlvbiBi
YXJyaWVycw0KICAgICAgICAgKiBvbiBvbmUgb3IgbW9yZSB0YXNrKHMpIHdpdGhpbiB0aGUgZ3Vl
c3QuIFRoaXMgZ3VhcmRzIGFnYWluc3QgdGhlDQogICAgICAgICAqIHNjZW5hcmlvIHdoZXJlIHRo
ZSBndWVzdCBoYXMgc2VwYXJhdGUgc2VjdXJpdHkgZG9tYWlucyBvbiBzZXBhcmF0ZQ0KICAgICAg
ICAgKiB2Q1BVcywgYW5kIHRoZSBrZXJuZWwgc3dpdGNoZXMgdkNQVS14IG91dCBmb3IgdkNQVS15
IG9uIHRoZSBzYW1lDQogICAgICAgICAqIHBDUFUsIGJlZm9yZSB0aGUgZ3Vlc3QgaGFzIHRoZSBj
aGFuY2UgdG8gaXNzdWUgaXRzIG93biBiYXJyaWVyLg0KICAgICAgICAgKiBJbiB0aGlzIHNjZW5h
cmlvLCB0aGUgc3dpdGNoX21tKCkgLT4gY29uZF9taXRpZ2F0aW9uIHdvdWxkIG5vdA0KICAgICAg
ICAgKiBpc3N1ZSBpdHMgb3duIGJhcnJpZXIsIGJlY2F1c2UgdGhlIHZDUFVzIGFyZSBzaGFyaW5n
IGEgbW1fc3RydWN0Lg0KICAgICAgICAgKi8NCiAgICAgICAgaWYgKCghYnVkZHkgfHwgV0FSTl9P
Tl9PTkNFKGJ1ZGR5LT52bWNzICE9IHByZXYpKSAmJg0KICAgICAgICAgICAgIW1zcl93cml0ZV9p
bnRlcmNlcHRlZCh2bXgsIE1TUl9JQTMyX1BSRURfQ01EKSkNCiAgICAgICAgICAgIGluZGlyZWN0
X2JyYW5jaF9wcmVkaWN0aW9uX2JhcnJpZXIoKQ0KICAgIH0NCg0KSWYgdGhlIGd1ZXN0IGlzbuKA
mXQgZXZlciBpc3N1aW5nIElCUEIsIHRoZXkgb25lIGNvdWxkIHNheSB0aGF0IHRoZXkgZG8gbm90
IGNhcmUNCmFib3V0IHZDUFUtdG8tdkNQVSBhdHRhY2sgc3VyZmFjZS4NCg0KVGhvdWdodHM/DQoN
Cj4gDQo+PiBUaGF0IHNhaWQsIHNpbmNlIEkganVzdCByZS1yZWFkIHRoZSBkb2N1bWVudGF0aW9u
IHRvZGF5LCBpdCBkb2VzIHNwZWNpZmljYWxseQ0KPj4gc3VnZ2VzdCB0aGF0IGlmIHRoZSBndWVz
dCB3YW50cyB0byBwcm90ZWN0ICppdHNlbGYqIGl0IHNob3VsZCB0dXJuIG9uIElCUEIgb3INCj4+
IFNUSUJQIChvciBvdGhlciBtaXRpZ2F0aW9ucyBnYWxvcmUpLCBzbyBJIHRoaW5rIHdlIGVuZCB1
cCBoYXZpbmcgdG8gdGhpbmsNCj4+IGFib3V0IHdoYXQgb3VyIOKAnGNvbnRyYWN04oCdIGlzIHdp
dGggdXNlcnMgd2hvIGhvc3QgdGhlaXIgd29ya2xvYWRzIG9uDQo+PiBLVk0gLSBhcmUgdGhleSBl
eHBlY3RpbmcgdXMgdG8gcHJvdGVjdCB0aGVtIGluIGFueS9hbGwgY2FzZXM/DQo+PiANCj4+IFNh
aWQgYW5vdGhlciB3YXksIHRoZSBpbnRlcm5hbCBndWVzdCBhcmVhcyBvZiBjb25jZXJuIGFyZW7i
gJl0IHNvbWV0aGluZw0KPj4gdGhlIGtlcm5lbCB3b3VsZCBhbHdheXMgYmUgYWJsZSB0byBBKSBp
ZGVudGlmeSBmYXIgaW4gYWR2YW5jZSBhbmQgQikNCj4+IGFsd2F5cyBzb2x2ZSBvbiB0aGUgdXNl
cnMgYmVoYWxmLiBUaGVyZSBpcyBhbiBhcmd1bWVudCB0byBiZSBtYWRlDQo+PiB0aGF0IHRoZSBn
dWVzdCBuZWVkcyB0byBkZWFsIHdpdGggaXRzIG93biBob3VzZSwgeWVhPw0KPiANCj4gVGhlIGlz
c3VlIGlzIHRoYXQgdGhlIGd1ZXN0IHdvbid0IGdldCBhIG5vdGlmaWNhdGlvbiBpZiB2Q1BVMCBp
cyByZXBsYWNlZCB3aXRoDQo+IHZDUFUxIG9uIHRoZSBzYW1lIHBoeXNpY2FsIENQVSwgdGh1cyB0
aGUgZ3Vlc3QgZG9lc24ndCBnZXQgYW4gb3Bwb3J0dW5pdHkgdG8gZW1pdA0KPiBJQlBCLiAgU2lu
Y2UgdGhlIGhvc3QgZG9lc24ndCBrbm93IHdoZXRoZXIgb3Igbm90IHRoZSBndWVzdCB3YW50cyBJ
QlBCLCB1bmxlc3MgdGhlDQo+IG93bmVyIG9mIHRoZSBob3N0IGlzIGFsc28gdGhlIG93bmVyIG9m
IHRoZSBndWVzdCB3b3JrbG9hZCwgdGhlIHNhZmUgYXBwcm9hY2ggaXMgdG8NCj4gYXNzdW1lIHRo
ZSBndWVzdCBpcyB2dWxuZXJhYmxlLg0KDQo=
