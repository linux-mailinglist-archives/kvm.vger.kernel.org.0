Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8935F534215
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 19:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbiEYRPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 13:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiEYRPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 13:15:34 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61283AE261;
        Wed, 25 May 2022 10:15:31 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGfndE020734;
        Wed, 25 May 2022 10:14:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=EEUwoDYWFbzyDmr7XDEgyvV6bEgYpA+YHVizqBb4WpE=;
 b=KRlSN0+NROtvCesXfK1Uy4jf7GF+2aGAI41xW8D+qnpPJw6frub8TM68Pr74NjJHK7QK
 RNbCt/3C1pyccVvHLu5V+SRM4SC3r8l0q7bUrrhkhFIhRUT10j+HmerRcBQ8oEZvP1yq
 DnAjqwHOIBqOMN14UZ+LerNbZu+tNLkfiNm2UnlDq8m8KLAPP3DTSDfAC12shB69YiUg
 7xD5Of9V5//XaJxuwjDhKoIGTBwJuOyBk1Dt/5UrWwh/J3e2YkqtfjV6GzU+sbKeoui1
 6eXHVjF/V6Kz5opjmURw2smv536/uJiLk60LDeM4Pnd3hqkBGHFeYmg6LTRZl66NeqtX ug== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3g93u62hch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 10:14:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZWxmhMYG0X1KUgJI00J6UFt+iSwUVabtbO9qJfWLQT153rxG6a5LzCjyg1uQdAkN8KQiBSBy4XBRvoCiFaIgWlLiWFwBOxjVFECpYjnLpzayeh2LUghCZ1KsjXuRzA+56HgrUN6FGzUZmopPSt7j075ew34A1uFFRFguxaPRFU6UryGUn9gak0IM0H5IwtHFNvFx56SyumPDWFq7QcwC3YgmPbsiJTJsM5f65pvUGS0IkTJrtjYNPzsNxuSMT6Vn/vDuLXPro4NS5cX1f/xPW+Ao/fi8cgi9VF5eNy0cM/wOMEidPZYd/kSpamwiJNGfHzP56pr4Zddn9wfFmymYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEUwoDYWFbzyDmr7XDEgyvV6bEgYpA+YHVizqBb4WpE=;
 b=ByzTjY9+NQN6RojLn0Pf4iA9igXcyD9b+aRfovfnWDtQcFCmy8ZCYPGnbGOnu81Hh1uBKGET4L9K+FvRUZ4LMeveKFVTVa7EnAPcv0IvV2zLEiWanRvLute9N3gHJHeNwECInBUtjS9ZqK+Ll31cv4SzCj1lXcCdfrNlDG4YavN8kCZ9pQ5Xsf3lcmDNl1xmo84yxhXHYxNTkIAL90fM8ImGBfmxrVu7NS9kyvep77IHOmB3+eRDb/P840u+kkcucu1w5FqytWMbZDqHYepjZeiIiDlMRA4DsKJn6mMORAGrnreAHTWhsrCMyd4O8s3VsuNb+s87sp7UXFyyu4Upjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN6PR02MB3220.namprd02.prod.outlook.com (2603:10b6:405:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 17:14:38 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 17:14:38 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Topic: [PATCH v3] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Index: AQHYbIo8QUPSNZgQlU6uXTApFCUdfa0v2eSAgAAC2oA=
Date:   Wed, 25 May 2022 17:14:38 +0000
Message-ID: <3C8F5313-2830-46E3-A512-CFA4A24C24D7@nutanix.com>
References: <20220520204115.67580-1-jon@nutanix.com>
 <Yo5hmcdRvE1UrI4y@google.com>
In-Reply-To: <Yo5hmcdRvE1UrI4y@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01316c87-4c9c-48c6-64a3-08da3e720c84
x-ms-traffictypediagnostic: BN6PR02MB3220:EE_
x-microsoft-antispam-prvs: <BN6PR02MB3220CDF3ED0C892EC03E8523AFD69@BN6PR02MB3220.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9RSlmf4Q9WLs0CO8V+JJ1sos97jQFbWLuUMzcUmGu4f1ixYvNpwnQkh6sBtF8fE9UZ6X2HYt7bjJWPzMda0LF2yTdSLx56QIKCEhJ8BXgcsP8d86VyEm0Np0RwrbyxMKzvY8VmoFEm+pHfx18+7Z/GwgPczKGSijXDta4XshuEN4JT1rerXW1PsqVQeKfCozFimWI6vgWMZcyRqg/vrPfa4u3JCVXdJQ69eQftpUcNJWBlpKR9HTGLn1MwsM3cLOxQ0zXY9q2NNoZlE30xt5TnzV6HBSF/Fk4SpVinUz3wlodZ3xi8/AC0OfwB0/iEQkq1/XORJzlYz6pWntrCkQH68dyDQ9vPx9t5OE2IKw0Kdo9Nb3gMSDfFpRfloaS2x19ZwFCESlpaTZc8fdT6Zu/1uYhUC2xleECIaNR9i8V+yB9wdIzEQqppsBXqUf7kfIzprtf+Kf9QOvXWTR4146vlJ+hKAvVmbUsq2HsV0HmUm4jseaQABq8WRbQ5ZLPXzN7me1nyZCcWL5dVh82Iu05u4124z5MbbzMLEyRindFjtIXQaChsVio1vTonIKgK5XDB47zW92FnJqxBijmsA8EMnMKBg/F2imPU2KKwie1o+S7vFq9JH4J7ZTf0U9w+639xokw9eoKqcwAJ8dQeXXOAzZBDfcaXvauwFx+XCqFEkwjwVcbEJGxHJizWmYJm2LCumhOVFbTZLNczt+bgTRdW/LrNU3o/hhcLv0O5oR02U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(83380400001)(33656002)(2906002)(6916009)(86362001)(53546011)(54906003)(6506007)(8936002)(122000001)(71200400001)(38100700002)(38070700005)(6512007)(316002)(36756003)(186003)(66446008)(66476007)(66556008)(8676002)(66946007)(64756008)(4326008)(2616005)(91956017)(508600001)(76116006)(6486002)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0IrUmt1NTV4UVAvSlZRODJoRUZGU0RmM1ZKUVFXUFZDSFJPUDhUNTk1VU92?=
 =?utf-8?B?NFJpcWNrZEQyN3Nzd1AycDRUbzRxaG5KbGR5N0RHNjB2MmNLaEtZTFNpS2ZL?=
 =?utf-8?B?Q1V5RjNwK3cwOGwvSXp2MTJtM3NFNlpZeTdsdjEzUEcrQzV3RmsrVTNqK3A3?=
 =?utf-8?B?dWM3bXNrRWVaQVlqckt2dXl6eXpWWTMwRHp4N0ZXRVNyTzZBSlBLUHIvNmpw?=
 =?utf-8?B?YWU4VnducjNrNGRLbFRxVHQ1WGlEK0ZaSmx1L21FN0dJNG11K1lnZFlVTXRH?=
 =?utf-8?B?NG83ak9WWjN0QmxzTnMrdzA0a1FoVUg0NzNyVWVtUU0xdHU3UjdoR3FpSEJ6?=
 =?utf-8?B?SEppYysrTk5oTTRVRWJ0Zm9Wc0dVY3BUUEtTVHJUSDJoZFdXUzRGWHFMNFAx?=
 =?utf-8?B?TnlxSk9LenkwWEJkZHhKRzBnOEFSUDk0SDRVVmg2Rld1YTgrUFFsWG9yOTk2?=
 =?utf-8?B?dFlxbVB2eUY1NkZtMWJYc0twMXZPSzVpdzV0R3R6QlRESlZTSDVXYjJ0bk5Q?=
 =?utf-8?B?MGdZZ0RBcGpuc3JiSkFWQUNiR2hScHJKV0NVc1pNbk1ITXZIakx1ZVJzbGhl?=
 =?utf-8?B?TFFic1ppd3I2d29SVWl0N1VHKzNmS3lBUXM2VE1kUHkrRWkrTHNrdlg1NDQw?=
 =?utf-8?B?SWhodG1Vb0wrWGl3dVRzMGYzUzI5MlN3WjJDa0oxbnMyNVZvcWhra1VraTJy?=
 =?utf-8?B?N3R3M0JISE5hZzI4MUNrbE9FL0x6SEQxZTZRTmNKUnJWR0xNWWtZZ3E3Qkto?=
 =?utf-8?B?em1Va3h1M3VjdWdVc2U3WmRLRGhjSE1DczhFMm1nNVN3RlZmSVUxR3A2NE5K?=
 =?utf-8?B?SjVxN1pKWHFsS3hEdlF0U3c4WHR0bHJMMUl0bG9HMDJla3J6NGJEd1dDZXdv?=
 =?utf-8?B?UmoxN1AvTzZzY1pHd3E2Qm9oUTVicjgxcW1LVi9sS29TTEFZaWNNSDN3OFdK?=
 =?utf-8?B?YTRoNy81aFFDTWMwZzV0b0RxSG5obnVpWnl5UTUvcjAvZlZsUjhzclp0Sm5q?=
 =?utf-8?B?Tnc2K0pQakwrUytJbG5hSGpJeS9ndEY1RlpHMHgxZXVXTDIvSEVxU3FzUVhV?=
 =?utf-8?B?WXNIdEw0QW9NcHJCNFhEeVlUcDFuY0F4VEJsY2FYWVpkWGMya2hTTFdhRGRW?=
 =?utf-8?B?NVdFQ3ZjTFN4Z2FYV01KUjg3OGhXcmZVQzhscjNMUFEwSmdBSlFoaEZMS3dt?=
 =?utf-8?B?ZWd5ZG8rSUVuSTNRcjhadWlNaDNTa0pMODU2ZDJ6RVNVSXBDcktVMTdBeFRN?=
 =?utf-8?B?anZFM2xPNmZZOWdVbWZlOTl5MjZtZm1wSDhzZG9EYkpjdnpQUER2VUZhS3pt?=
 =?utf-8?B?cHdIWU5sa0pvcmdUNG4wUUVTNm8zY1V2SzdpdHdUSTFPeVJ5S0lscFNHNU9O?=
 =?utf-8?B?OXdSYmtYcjR0cHNPcXlMMi8wTkwwdjB0NzdOb0hWblNSbE9YdndwaUZxazhC?=
 =?utf-8?B?RjY4d2p3ZFRiaklKMnNBTE5RRSttOVhzK0EzUVBWVWdaL2tjVVJHcXZLV2t0?=
 =?utf-8?B?SDRBaUF2U0NFdks5dnB1c0hOY3FKYlliMWZrK3dWZnk2cVZDUzZsYUh5ajly?=
 =?utf-8?B?NjV1QmFEcHhrM3hVbTA5RGlOUGhsaTZ1bnR4NnBCM1g4L1NpVjYxc1hsc1NV?=
 =?utf-8?B?NElrTTcrV21XS0dUWlNXd1FXaENwRHBlRmpGN2FqcWdRcWdMbWRGTnRPaUR2?=
 =?utf-8?B?dCtYMldXZ1htb09FQmx2VnVFYkEvOWQwYTR0ckRVcU5WSEJjN01Ba2VraFhq?=
 =?utf-8?B?dm1RenZZZERQSGZxckZzWGlsN01ueUUycVlKZFliMk9aRkp4STNLMmw1bnlC?=
 =?utf-8?B?QTJNWXlOYi9YNzA5N203ZG5IS0RNcjA5aUZTU0RFb2t1OStFZGExc0pnc3M2?=
 =?utf-8?B?S0VjOXVyZG92MHl5V1hTeXpJbC9tWmV0Y2R1dGlpU01Bdlp1VGxsblpVdU9P?=
 =?utf-8?B?UzM0bVd0T2R2Y04vZnhlbGRrQ29VdFVlR1JXV0pVM1gwNlA3aHJvS0lIQXZs?=
 =?utf-8?B?emM3T2p3YVlMUWwzS0FQMlpPK0l6Q0hNbFk0TWpSb2NVYTRNdU9NeGsxNlk0?=
 =?utf-8?B?UW5hQ2JjMlhwL2xCU3haVkVFdHFUbERDVk94dUtCRy9JeVZtZ2NUVXdPWW5m?=
 =?utf-8?B?akxYandsNkJ6RnczbFlOVm5TNWdhdy9PZGUwMWxJT2x5YnhtOTRFOFljNUto?=
 =?utf-8?B?cERORHpURkV6d1ArYlA3dk51WGJmYXZZSjI2Tnp6Y2JmV1hFYWIvdUJheWN1?=
 =?utf-8?B?SGN4ZjJRenBNaWNEODVqWmRDaEQ2VVBIN2sweStITFZJVGJWNTVKMkNueVFv?=
 =?utf-8?B?RWlKMmlNdnNqbjlXNmtKTlFoRDFzaHB2bXRQbHo2QVl5a0RPeWNSM1BWTFRW?=
 =?utf-8?Q?F5JL1Lwc5i4zd+qbSIx/EmsTLKaOiROqOyjwhRxsM+Eyb?=
x-ms-exchange-antispam-messagedata-1: Q7chkJUaHXgR+HI0b3WW0xIagSrTYT1bFUk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <857D3FCD0B2A874791C66D2C0342D53A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01316c87-4c9c-48c6-64a3-08da3e720c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 17:14:38.3230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Mk88wNhO2qIEjPUrtFAxtbkQBtokXJQgq5tGjkhOxAUDZQD8eKfhRCD+lmYJDygnumQD9d01olftSrRDbUULIvluveC0rYRIrCV1AjXJ14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB3220
X-Proofpoint-ORIG-GUID: kgRu5fekkfCeuRFCVdFk0JAdbDiKxg_P
X-Proofpoint-GUID: kgRu5fekkfCeuRFCVdFk0JAdbDiKxg_P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_04,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDI1LCAyMDIyLCBhdCAxOjA0IFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIE1heSAyMCwgMjAyMiwgSm9u
IEtvaGxlciB3cm90ZToNCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIv
YXJjaC94ODYva3ZtL3ZteC92bXguYw0KPj4gaW5kZXggNjEwMzU1YjljY2NlLi4xYzcyNWQxN2Q5
ODQgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+PiArKysgYi9hcmNo
L3g4Ni9rdm0vdm14L3ZteC5jDQo+PiBAQCAtMjA1NywyMCArMjA1NywzMiBAQCBzdGF0aWMgaW50
IHZteF9zZXRfbXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3Jf
aW5mbykNCj4+IAkJCXJldHVybiAxOw0KPj4gDQo+PiAJCXZteC0+c3BlY19jdHJsID0gZGF0YTsN
Cj4+IC0JCWlmICghZGF0YSkNCj4+ICsNCj4+ICsJCS8qDQo+PiArCQkgKiBEaXNhYmxlIGludGVy
Y2VwdGlvbiBvbiB0aGUgZmlyc3Qgbm9uLXplcm8gd3JpdGUsIHVubGVzcyB0aGUNCj4+ICsJCSAq
IGd1ZXN0IGlzIGhvc3RlZCBvbiBhbiBlSUJSUyBzeXN0ZW0gYW5kIHNldHRpbmcgb25seQ0KPiAN
Cj4gVGhlICJ1bmxlc3MgZ3Vlc3QgaXMgaG9zdGVkIG9uIGFuIGVJQlJTIHN5c3RlbSIgYmx1cmIg
aXMgd3JvbmcgYW5kIGRvZXNuJ3QgbWF0Y2gNCg0KQWggcmlnaHQsIHRoYW5rcyBmb3IgY2F0Y2hp
bmcgdGhhdA0KDQo+IHRoZSBjb2RlLiAgQWdhaW4sIGl0J3MgYWxsIGFib3V0IHdoZXRoZXIgZUlC
UlMgaXMgYWR2ZXJ0aXNlZCB0byB0aGUgZ3Vlc3QuICBXaXRoDQo+IHNvbWUgb3RoZXIgbWlub3Ig
dHdlYWtpbmcgdG8gd3JhbmdsZSB0aGUgY29tbWVudCB0byA4MCBjaGFycy4uLg0KDQpSRSA4MCBj
aGFycyAtIHF1aWNrIHF1ZXN0aW9uIChhbmQgZm9yZ2l2ZSB0aGUgc2lsbHkgcXVlc3Rpb24gaGVy
ZSksIGJ1dCBob3cgYXJlIHlvdQ0KY291bnRpbmcgdGhhdD8gSeKAmXZlIGdvdCBteSBlZGl0b3Ig
Y3V0dGluZyBhdCA3OSBjb2xzLCB3aGVyZSB0YWIgc2l6ZSBpcyBhY2NvdW50ZWQNCmZvciBhcyA0
IGNvbHMsIHNvIHRoZSBsb25nZXN0IGxpbmUgb24gbXkgc2lkZSBmb3IgdGhpcyBwYXRjaCBpcyA3
Mi03MyBvciBzby4NCg0KVGhlc2UgYWxzbyBwYXNzIHRoZSBjaGVja3BhdGNoLnBsIHNjcmlwdCBh
cyB3ZWxsLCBzbyBJIGp1c3Qgd2FudCB0byBtYWtlIHN1cmUNCmdvaW5nIGZvcndhcmQgSeKAmW0g
Zm9ybWF0dGluZyB0aGVtIGFwcHJvcHJpYXRlbHkuDQoNCkxldCBtZSBrbm93IGFuZCBJ4oCZbGwg
aW5jb3Jwb3JhdGUgYWxsIG9mIHRoaXMgaW50byBhIHY0IGFmdGVyIEkgaGVhciBiYWNrIDopDQoN
Cj4gDQo+IAkJLyoNCj4gICAgICAgICAgICAgICAgICogRGlzYWJsZSBpbnRlcmNlcHRpb24gb24g
dGhlIGZpcnN0IG5vbi16ZXJvIHdyaXRlLCBleGNlcHQgaWYNCj4gCQkgKiBlSUJSUyBpcyBhZHZl
cnRpc2VkIHRvIHRoZSBndWVzdCBhbmQgdGhlIGd1ZXN0IGlzIGVuYWJsaW5nDQo+IAkJICogX29u
bHlfIElCUlMuICBPbiBlSUJSUyBzeXN0ZW1zLCBrZXJuZWxzIHR5cGljYWxseSBzZXQgSUJSUw0K
PiAJCSAqIG9uY2UgYXQgYm9vdCBhbmQgbmV2ZXIgdG91Y2ggaXQgcG9zdC1ib290LiAgQWxsIG90
aGVyIGJpdHMsDQo+IAkJICogYW5kIElCUlMgb24gbm9uLWVJQlJTIHN5c3RlbXMsIGFyZSBvZnRl
biBzZXQgb24gYSBwZXItdGFzaw0KPiAJCSAqIGJhc2lzLCBpLmUuIGNoYW5nZSBmcmVxdWVudGx5
LCBzbyB0aGUgYmVuZWZpdCBvZiBhdm9pZGluZw0KPiAJCSAqIFZNLWV4aXRzIGR1cmluZyBndWVz
dCBjb250ZXh0IHN3aXRjaGVzIG91dHdlaWdocyB0aGUgY29zdCBvZg0KPiAJCSAqIFJETVNSIG9u
IGV2ZXJ5IFZNLUV4aXQgdG8gc2F2ZSB0aGUgZ3Vlc3QncyB2YWx1ZS4NCj4gCQkgKi8NCg0KVGhh
bmtzIGZvciB0aGUgc3VnZ2VzdGlvbiwgdGhpcyB0ZXh0IHdvcmtzIGZvciBtZQ0KDQo+IA0KPj4g
KwkJICogU1BFQ19DVFJMX0lCUlMsIHdoaWNoIGlzIHR5cGljYWxseSBzZXQgb25jZSBhdCBib290
IGFuZCBuZXZlcg0KPiANCj4gVWJlciBuaXQsIHdoZW4gaXQgbWFrZXMgc2Vuc2UsIGF2b2lkIHJl
Z3VyZ2l0YXRpbmcgdGhlIGNvZGUgdmVyYmF0aW0sIGUuZy4gcmVmZXINCj4gdG8gInNldHRpbmcg
U1BFQ19DVFJMX0lCUlMiIGFzICJlbmFibGluZyBJQlJTIi4gIFRoYXQgbGl0dGxlIGJpdCBvZiBh
YnN0cmFjdGlvbg0KPiBjYW4gc29tZXRpbWVzIGhlbHAgdW5mYW1pbGlhciByZWFkZXJzIHVuZGVy
c3RhbmQgdGhlIGVmZmVjdCBvZiB0aGUgY29kZSwgd2hlcmVhcw0KPiBjb3B5K3Bhc3RpbmcgYml0
cyBvZiB0aGUgY29kZSBkb2Vzbid0IHByb3ZpZGUgYW55IGFkZGl0aW9uYWwgY29udGV4dC4NCg0K
T2sgdGhhbmtzIGZvciB0aGlzIGFzIHdlbGwsIEkgYXBwcmVjaWF0ZSB0aGUgZmVlZGJhY2shDQoN
Cj4gDQo+PiArCQkgKiB0b3VjaGVkIGFnYWluLiAgQWxsIG90aGVyIGJpdHMgYXJlIG9mdGVuIHNl
dCBvbiBhIHBlci10YXNrDQo+PiArCQkgKiBiYXNpcywgaS5lLiBtYXkgY2hhbmdlIGZyZXF1ZW50
bHksIHNvIHRoZSBiZW5lZml0IG9mIGF2b2lkaW5nDQo+PiArCQkgKiBWTS1leGl0cyBkdXJpbmcg
Z3Vlc3QgY29udGV4dCBzd2l0Y2hlcyBvdXR3ZWlnaHMgdGhlIGNvc3Qgb2YNCj4+ICsJCSAqIFJE
TVNSIG9uIGV2ZXJ5IFZNLUV4aXQgdG8gc2F2ZSB0aGUgZ3Vlc3QncyB2YWx1ZS4NCj4+ICsJCSAq
Lw0KPj4gKwkJaWYgKCFkYXRhIHx8DQo+PiArCQkJKGRhdGEgPT0gU1BFQ19DVFJMX0lCUlMgJiYN
Cj4+ICsJCQkgKHZjcHUtPmFyY2guYXJjaF9jYXBhYmlsaXRpZXMgJiBBUkNIX0NBUF9JQlJTX0FM
TCkpKQ0KPiANCj4gQWxpZ24gdGhlIHR3byBoYWx2ZXMgb2YgdGhlIGxvZ2ljYWwtT1IsIGkuZS4N
Cj4gDQo+IAkJaWYgKCFkYXRhIHx8DQo+IAkJICAgIChkYXRhID09IFNQRUNfQ1RSTF9JQlJTICYm
DQo+IAkJICAgICAodmNwdS0+YXJjaC5hcmNoX2NhcGFiaWxpdGllcyAmIEFSQ0hfQ0FQX0lCUlNf
QUxMKSkpDQo+IAkJCWJyZWFrOw0KDQpBY2sgb24gdGhpcw0KDQo=
