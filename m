Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1558E4D0431
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 17:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiCGQdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 11:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244185AbiCGQdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 11:33:40 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eus2azon11020017.outbound.protection.outlook.com [52.101.56.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AC13A715;
        Mon,  7 Mar 2022 08:32:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWyASx0QFh1emtVU9aUMC3NbTJeTiLNgvoWxqC6DrgH/ZOvzS7atLWOset5UxKElV0z2dvVMkemRSWCQt8Ig0Y/3A1gj6e0ydfN07gmqvvR8gnRhSjwUsVJjBAR+IoK4p4pXVsvt5kCLdTptPun0lE0KS2TekgJwRxKTkpTbVP3LKxpZ3nykdDiszZtFwxfQqHtJo62IbeyAYwfVtERb4BoytsGmFSw+BJqEmk8hYe9JDMEj8r1sOo96lOQ5zfN6v/mPyRx3wavcjEFUJIO4ELkgEU7b4i372tFJwxg4Bc1vhBRd8YjpQwRFe361RQcoD/J1woELLr1mdCPLpglH/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUKjTfpNW5Y8Us5Jea/iFkRluY1b1wdXjfhYy8lIn8c=;
 b=OsbTIupZeOS3cWsTQbKmEhcqXZvhAs3MiYXH2s+NSHUx0KhFb6ptCWX5KyIPDYDNAVWRmDgm6AZ3CFNDj6+QE2huK9RnFGugy+h3qScj+SRs/M8BIDUqCxRUvFm6kW3xXVc8K1Q6BieFZj1siQS6gRsL2D9ev74eLb+dq/vlIIZchyXz6dL+DbidLs515Gbcu2ZMFerqlDTWEQ0QLWZAK3Coh6YZZ/oBIhPaFySjvZsU3732GRDZgE9kVaA+78rS5B2fuAgzGpeVEiBzMryVv28yP2VvQporS9wxTboJuXN08VyYIyhwetepvU9bDcuSqbUwLJc/PCyPv5O0jK6kpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUKjTfpNW5Y8Us5Jea/iFkRluY1b1wdXjfhYy8lIn8c=;
 b=QpMenUrgwXTzgtdPRnz0F0z15db9ZcR8RyU9Fr5OGE+tYibdtYHW2lPanhXinX1zKqWhxO/C/0pBrbeixhYoOYM0zYoGH5lVf0/Xyu/7uhreyS+oTYahChCdINs8Ocod9oj1Cr9tQ8P/fIXkSVmTPplqYI0QcaH0mHnAmykhNXg=
Received: from MN0PR21MB3098.namprd21.prod.outlook.com (2603:10b6:208:376::14)
 by BL0PR2101MB1123.namprd21.prod.outlook.com (2603:10b6:207:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.5; Mon, 7 Mar
 2022 16:32:39 +0000
Received: from MN0PR21MB3098.namprd21.prod.outlook.com
 ([fe80::a0b3:c840:b085:5d7b]) by MN0PR21MB3098.namprd21.prod.outlook.com
 ([fe80::a0b3:c840:b085:5d7b%8]) with mapi id 15.20.5061.008; Mon, 7 Mar 2022
 16:32:39 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC 15/19] x86/hyperv: Fix 'struct hv_enlightened_vmcs'
 definition
Thread-Topic: [PATCH RFC 15/19] x86/hyperv: Fix 'struct hv_enlightened_vmcs'
 definition
Thread-Index: AQHYMjMDO+C8XTBGx06fidjLKusFAqy0HTQw
Date:   Mon, 7 Mar 2022 16:32:39 +0000
Message-ID: <MN0PR21MB3098C422061D13B6F7803EDFD7089@MN0PR21MB3098.namprd21.prod.outlook.com>
References: <20220307145023.1913205-1-vkuznets@redhat.com>
 <20220307145023.1913205-16-vkuznets@redhat.com>
In-Reply-To: <20220307145023.1913205-16-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=369791a4-960d-43d3-a295-367b9688e0c5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-03-07T16:31:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4921fabb-9899-4fb0-ce7d-08da0058185e
x-ms-traffictypediagnostic: BL0PR2101MB1123:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BL0PR2101MB1123EC7DCF9F15160A850526D7089@BL0PR2101MB1123.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SoXjn+XD7QBuIBbsM5DpZbBWzTORAH/3jg/Pdu4xuipzBycPNFUFZ7CsHjMeUF4leCT93JI8OduvaCgcAWEYY4b6KDy+pWxCeD6Ob35Ssm/IYUWA7ept0DqiCoPrkDq+4ec5g6mg/1jRNSrZNlNS1l7KJHGNSGP+4j7iRnAmLB+ED1WPk5CCmhWWIPtaDJB/I7jREUf6m71R7sR1YZvigXLdGuv/dqJOZY7COuujYePw0mm0nlpvw8ozRw8Q8xxeEpWuE8WCXoUKccGO1jr33JQ8S1Def84fb8s2Lqkq6KTsDNUGKLv1oyoudCKK5OOGJT3UOIZCRN+RdqlnoIaY9MyVUaUuWkcevrnLTk2zEnqPB2XrtcxrTJPomHAVq1COOB9OVDMRVGFnqXyFPROIxS5y54RJ6WmCDO4kL/6vNmkFcKcJhHl7RB3k0gU4+FC3U/nQCkwkoWIi8rtocRHt31RiB8h8Ur0CGslbWrnm7WECM9314yHqgm4eg0ZXw1LjW8DtZoDtEXiDb6+KOiFjCp0oNqcTsu9mNg2NQKMNLDdtD+dTaB9hZ5fc4/DptGilEI9TaKhWOA+CMK5Tz9iO+2paEJ0fSBurIc5zu5leMXn1sYXQ7DpwGoT8FRJvIfSKjeXN2EkNtAieRk9E9WQriyTKWJbjLXHvYISNXL27qSosCBtBtmKHqP0Dxu8Vb1/gr2PPfr+PiLxmF7bMC1jSQiIOcqlFN2JwOppxqcSYnwb3JINR7bRnlH7oy42j68gk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR21MB3098.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(508600001)(8676002)(83380400001)(2906002)(5660300002)(186003)(38100700002)(8936002)(82960400001)(10290500003)(82950400001)(26005)(8990500004)(86362001)(76116006)(66446008)(66946007)(64756008)(66556008)(66476007)(110136005)(55016003)(316002)(7696005)(9686003)(38070700005)(4326008)(54906003)(71200400001)(33656002)(6506007)(122000001)(451199004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F8i3qvDLVtHl/kk+MmnaDKLYUjJl7vrL6BzjGbCw6w5ofmaD8ARGm/MmUvDG?=
 =?us-ascii?Q?MMjT8lNdsXSoZN0NjHxV8ptsZqKxFiR9tzwlzSr9ye1FOZ+E4N4SJPI4Vjgs?=
 =?us-ascii?Q?L9ZJcN35/2k7IWRhJuA7UV2isFOfYUtBX2xpBt3W2KpjO0gZZcwXPoOl91+p?=
 =?us-ascii?Q?RepXqBF3vHG96kzLU8nn4O4JaxQaMZZdhacmy4q/a+TW1aSaqRmXeDAANsba?=
 =?us-ascii?Q?7IhOx15pFiFO9Pbmn6YBhrXwFM0G5TQ09AJE3GJ/qzn5U927oYInwC8mxQ5l?=
 =?us-ascii?Q?O9MgDzffTkBPUhJTb3CF4H+Yj+HwvAruFGlBKrtnAw6tjC93C2ccTg64F2gc?=
 =?us-ascii?Q?0ZqjrP4npIrj25IS064FBx1Eno5iHj0P3lZsIRbRXx5YUSl0bvhpZOP2YNCn?=
 =?us-ascii?Q?nahrKc+mj5++nuHrnxRN1ZjM0GZOEZm6myLtCOpGe3ICaytcRJO/7hd6s6br?=
 =?us-ascii?Q?EfcUsr0qZVqFqc/PKxZ8mrLgqYRteM7j28R3xiu7Eeo8A+bzSywwHF54uDhl?=
 =?us-ascii?Q?Xm5Vcsg3zprUP2Cm9TKR6fbtWPFlCWWea8nsrY8gxyScYmmAC5GupceS2G1N?=
 =?us-ascii?Q?1/wqeCeLJFg9SBs5TIMHQ946olwdWSlH/2ZZsfVY3ww7gNoGVmsKCBkMxcZT?=
 =?us-ascii?Q?I8t/V5zrYZbi1Vu+8By0uxPPgd8bDjXgm5d7DGhzxUCYHyQMoubjDAzj4e/i?=
 =?us-ascii?Q?ZM3Nme3kibNI3iOtB9uAhqSq7jIf9eA+vR/obbG3Ia0yT4zLxKcB+E6F9GH5?=
 =?us-ascii?Q?/GnMe04hVudKq5aKNyahztv/FyroyHNpn59GbRsbDeX74HA5ccgIOzWIT7zC?=
 =?us-ascii?Q?LdcwA16Vkln0Xy9TqlfX88Sph4sObJuOiM1JsTby/eI/+b0PH4rr9d1onsJv?=
 =?us-ascii?Q?xyoxoA/NGvHXWxa97Pmnk9NWDNM/6FlsAVAUBqEx3T8AKtclhWCkSV0as1yY?=
 =?us-ascii?Q?yfMdhMkUPYyltADt6LEhlvOpzPp9GpDBzZxCnz+ktKyVilD9vqc2dfcNNTC3?=
 =?us-ascii?Q?ywelHnhjWmmhdDZAhljNw4E2JqLbsGyRjZ+T1oNvm1JxKd1+yTZsGsHs2JDv?=
 =?us-ascii?Q?pA3RR6mAV8k93MurTDDNCHkdYOYsNyUqrKgm52En8fkZ8uJihiIyIotFSsFI?=
 =?us-ascii?Q?Py1N3N55n/z86LIZ9sooh3lrLls84m79IClDMa39rvXszl+iBuaT8mQVrPZc?=
 =?us-ascii?Q?qc7e5RHPZ7YmlRwxO0pqhL52QwnpIKymEE1DuQHjlks8sOMhVZvhYpiyfSzO?=
 =?us-ascii?Q?hZxjiAr+5aNy35IonsmkiXn9bihxnoTJEmvvwjS60iAo0ai8RM/HQ8cCyaZm?=
 =?us-ascii?Q?4vNfyjNgJbVbsH3edh/gu6BHJrWeZ+Yia60k58r3ptvhRIV4fBK+f6L7uTqB?=
 =?us-ascii?Q?Bdt5GrnQWY2lvFt1zM9Pfkq/8c25N9QOSCybtmue5lnwlx7w048HZNaB6Q+X?=
 =?us-ascii?Q?9rHAF69Qylbm82Cf/vv/urTfIpEwwXX1nmwy3acWDqBHopukiZIlPw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR21MB3098.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4921fabb-9899-4fb0-ce7d-08da0058185e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 16:32:39.0723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BUt7wtfskqId08BpHc81tTHI15GgR1ThLsIHM9kKgnRkRIAlfMZjaTyQ/9DJR1DtfLX7bRh/fmQxN0N36yMNxYhgJNdjMP08DRB6yZlXXoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1123
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Monday, March 7, 2022 6:=
50 AM
>=20
> Section 1.9 of TLFS v6.0b says:
>=20
> "All structures are padded in such a way that fields are aligned
> naturally (that is, an 8-byte field is aligned to an offset of 8 bytes
> and so on)".
>=20
> 'struct enlightened_vmcs' has a glitch:
>=20
> ...
>         struct {
>                 u32                nested_flush_hypercall:1; /*   836: 0 =
 4 */
>                 u32                msr_bitmap:1;         /*   836: 1  4 *=
/
>                 u32                reserved:30;          /*   836: 2  4 *=
/
>         } hv_enlightenments_control;                     /*   836     4 *=
/
>         u32                        hv_vp_id;             /*   840     4 *=
/
>         u64                        hv_vm_id;             /*   844     8 *=
/
>         u64                        partition_assist_page; /*   852     8 =
*/
> ...
>=20
> And the observed values in 'partition_assist_page' make no sense at
> all. Fix the layout by padding the structure properly.
>=20
> Fixes: 68d1eb72ee99 ("x86/hyper-v: define struct hv_enlightened_vmcs and =
clean
> field bits")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 5225a85c08c3..e7ddae8e02c6 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -548,7 +548,7 @@ struct hv_enlightened_vmcs {
>  	u64 guest_rip;
>=20
>  	u32 hv_clean_fields;
> -	u32 hv_padding_32;
> +	u32 padding32_1;
>  	u32 hv_synthetic_controls;
>  	struct {
>  		u32 nested_flush_hypercall:1;
> @@ -556,7 +556,7 @@ struct hv_enlightened_vmcs {
>  		u32 reserved:30;
>  	}  __packed hv_enlightenments_control;
>  	u32 hv_vp_id;
> -
> +	u32 padding32_2;
>  	u64 hv_vm_id;
>  	u64 partition_assist_page;
>  	u64 padding64_4[4];
> --
> 2.35.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
