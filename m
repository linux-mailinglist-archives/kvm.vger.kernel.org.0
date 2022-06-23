Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79996558B32
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 00:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiFWWXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 18:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFWWW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 18:22:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEBF62D4;
        Thu, 23 Jun 2022 15:22:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRuVS1yFZWES8AYnUjAsQTWJ1ChPB8iaonCac9ELJ+KmJ6wpvEWsjHtxJ9mU+QkeHdeh4mLS1ccFUxEZ8EInOlltJomm9r3OiE4Tmq/c9v3ZId98izIMkKDH0+13vH81diicH9sjlVMgnDMiaLw3EhqCsXrJsUwtKIrUSug8lEyHamSWdpQFwWNauk9qscET4ewYIEQYmFzHATBJuFRV8nYEK8eNkGn5L2m4gwaCbEAqfKQpVFV7BfEmLFhLl70GvQrTfxy6m4IBe5xZy0VD6Djx7RwauW1HElKP/JHSMEa1wUpMDGS48m/llrcokdwrn7vBVkPS/vm0AhobBdJLjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AH81Z2QrHJiFevRWk1nXMam6jNQmbermNSXNbIycy5k=;
 b=NGw/Ku6GpjaNM53vvKHwHG0QqYIXk6Gvo/undxu4r//aXMynAfAald5lAL+QPfeSL6tqfuRzHdRXpQEfuk5bWLgqrd0mgVf7036jXIqKD7uq8k2em/T1KtlV3ukcJvf4HJQo44/3Hk63qtaA0OTCGP/3wVSiGo0lt3A+RDxCuBklwZQ3BoEQ77tynk3bzImfvI8H9d/gjB1mzMLW00YkCVMd7Ais0SfYOIsJAmkyJVlauQ6nx4JCTBtMLrIS+9pSHmX3xNsPioIXCT4C0qO/nYkzG4sowLXr0vOFKyjCOVn1mXrHQ8hTm0O2UaEUWbFFImGuHBBuHnlt6mZo/pe4zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH81Z2QrHJiFevRWk1nXMam6jNQmbermNSXNbIycy5k=;
 b=A+DP8iNBBtNExlemi8+FD5QIWTkOLQFPIYpoF+mSMAnPvKvOyUQ1Dfowlxo9s3bLwx9ke6Eo8tY4iiaSwZ1GDK8uuj48L70QIoAv0OXQ2WVR5rEWn0Upj9Ee7ZmZy9Asq2OigAmD2tpWes6qQNFF/sfeZoa6VFt0nuQXV4pmmMg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 22:22:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 22:22:52 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Marc Orr <marcorr@google.com>
CC:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Topic: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Index: AQHYh0KYcxQqbwBTdUCpGH+ovKgAp61dj73A
Date:   Thu, 23 Jun 2022 22:22:52 +0000
Message-ID: <SN6PR12MB27672239E54FD0DD98A68EFB8EB59@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
 <CAA03e5FgfVQbz=pvMeBpOHENe5Rf_7UvE3iAqcgm=9nmwGEEBw@mail.gmail.com>
In-Reply-To: <CAA03e5FgfVQbz=pvMeBpOHENe5Rf_7UvE3iAqcgm=9nmwGEEBw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-23T22:18:14Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a347d247-b0e0-4cfd-a7e5-2ef85ac56a85;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-23T22:22:50Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 22e73bdd-a8ca-4747-8ebb-1fa4601d7963
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8676fb36-0964-48e2-694e-08da5566ea1d
x-ms-traffictypediagnostic: DM5PR12MB2391:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1NBy9r2meVsP102DbaNY9pEE4UHkzOQPLVtcz4D39Mx8Ngf1r/hkbucpLMk5Uqj+FqWFuqbU79MZo/iPufdiqdqidsAeak9i0i1lQxi102aww7EH/g9pkNfipzJ6izuezKgkgIZYaiLmC7DyuS6UdVhN/RCWP1shoxQjg1oIbiTdswxctefkuX9njlqnxmVbroPRX6lPJ3V8h4UBvnHtcvP6zA8Pq7CRdggOkbZViZdOwHeUFe/u/jzOPrOE/7SVsiPtx8hU+eokiROl0YtkC8fYzfQOeRjc+dnNkAm5GeTPWzyN5kvytIJxSQyop65X949lRfIVBnjDEUnNA4SW8Vpvo3PdvhXZIZ7JZM5fH1hWVx8vGOwprUeGLeVRtGkp4Y/Uneam8HlO4OAf8EvexjX0NYzDpCGhg5Z514enHYMYNvHFkACTMdY6K8ZYOcMVhSkj8ysgRDx54G3FjJCS7xuFC5KUJ61jyH5/q+kmPp4WF2nc1RH+QAKI+okGpu++4y8TDRiJnShj9qR+z8YrKBUcba0TwDCVc6LQ7tGkw2NOd9cGIDc8ZFZoK4azwRsEfYgHQns4AVUdPSFtWFB2DTZDiWQ+afVqxO8Cn/F/MwatliOwN6xJc7PnvGKlPDxmchyjv2oFSq1LO5DR5Ntztcynj/RC86SZ75Q9VMsqw1jQHec2pnFLi2UtveMy7DzQ8Y/89aRg4+TBn0Gnk3lmzXzd7QiVh7NH3PSHgK9Cu+8WRWfqDvrQpqOynFzIGHEB+Bo93m6QfaYeXIsLDgIShtjB0UOfHq9PJfati4fzJoE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(2906002)(33656002)(86362001)(38100700002)(7416002)(8936002)(5660300002)(52536014)(316002)(122000001)(4744005)(7406005)(66446008)(4326008)(76116006)(71200400001)(7696005)(6506007)(66476007)(55016003)(64756008)(6916009)(478600001)(186003)(66556008)(83380400001)(41300700001)(38070700005)(9686003)(66946007)(26005)(8676002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MoupNYrVcgukKJAOv1zcmDWoeqE7wxD3vYkXatqNHVemthevkr//OSR7un3Y?=
 =?us-ascii?Q?ea8AT5kClIVI49EWLIk2q/wHwfN29/HIV8VOcQmosc2qMpp86RbLdC7Nq2WA?=
 =?us-ascii?Q?dthoOdCnRDb3vMTNPL4SNYPSWsNcvEbD8vD8pgG6IT3tTjo3z5tiGub4lMMS?=
 =?us-ascii?Q?AmlOFPknxlRdBLIiTdQWYHtq5AoIha5y6654QvA0pYP67gq+WrJE439Jglmc?=
 =?us-ascii?Q?s7zQnawFoe5dJ6VYpNgeZUl3Y4EuJEzvxW+n6/+oMnoKsCSv2wHZLeNYAvYJ?=
 =?us-ascii?Q?lzAMu70BXYrxC0SaaNvZS6yMIspueh8SQZvvwd/usTyc4bhaeUqXeeHcC0Xm?=
 =?us-ascii?Q?WFBcsTMi4chEde64uZ11RiIgRfGI4DW3scJz5RxoF127uF3hSoeC+nG+zOOU?=
 =?us-ascii?Q?NL3zSJd3Ny82i8K5M2N8wh/GttyD9buNihrph4jhsDzNPbEUA6YAnElb2cRq?=
 =?us-ascii?Q?mlfgvTgkQGhHYqQ8iIQebKcIBSbCOPSY4QvxVPcWHZJ4TMHwrxrn8N47hyw7?=
 =?us-ascii?Q?FgH5nrJ5kJgzJmyVkn4AWH8STNOLpURQv3lmvzbxADlIk1yUBR4/0aLjaE8l?=
 =?us-ascii?Q?z3cl4jjpZRk/1/e5h5UJjFy/T95NEc96aBq64ONPj56t1KtI1pVJA/gizsqy?=
 =?us-ascii?Q?SWmlG45is9t/FpKhM0zCMY5U6susteZhtfJaEBPAfo4NQqy0Ww91sJEp+xUT?=
 =?us-ascii?Q?OleqXZnU0YIomRwuFj2mYgVqi8ylZJNtBGtLxf9OdEWFeJL9dd60YsTHBCNo?=
 =?us-ascii?Q?XJ9uq5tYESKAbqZ5gCfpnrgvAQ1WqDM/syoOisAaXPKn8bgieToUTK7HUiEr?=
 =?us-ascii?Q?sZ6sJVKo38zO9Ekr6GH8Hv7tHMzLD7HV2hveNif1+XyQbnbB1tAfTgl5RAuf?=
 =?us-ascii?Q?+J4SGOLeIGx5z2ZBtuLvBFjNnM3ekJWxQfdRyYYGIZZHNXop1BiqF4BrHKKh?=
 =?us-ascii?Q?/Fpe4xypBSZxhl8SNnyLxrHrQyOextigsk1XL4cfYo1mx+EdoEkfxdNtZY21?=
 =?us-ascii?Q?i7eqbreXXEgqFkkFyiM1v7q+AkeAbQFKWJaBEV2vQw9mEjJYDgPZ4LttwtEr?=
 =?us-ascii?Q?QdG8T+qDKHTUeV4Bn+Kq6iFbUzf+G/W/XognDpFxyZUsz7BgLhHMHq7byVf5?=
 =?us-ascii?Q?xaaJyfWlg97ZCjcW9Z8mHrXTBsVhQ0VIOXcLzo8QnBr12Ax1NdMe2he2PeVw?=
 =?us-ascii?Q?Ds+gY/a49HuwiqfwauYMYCUhjiR6ufeeve7y/gB9jjZHlUococArnUPiBYGb?=
 =?us-ascii?Q?2wvlP4fnB7kvwvHmhorJk91OL8y1ZZMQA+ozIVA5loQllj29zu4RcSJK7M8C?=
 =?us-ascii?Q?V0RDKr/D6UJ2lETK/FBXcsL1IiKja1VvmqaIV+MWzte+fi9eqc2YcHJjnAfw?=
 =?us-ascii?Q?H8AT73dR/nlLV2lgm4BIyGGQ0BO8Yz++4OvFZMePMSNxoXSrZypikWK9Ly6q?=
 =?us-ascii?Q?SNZ/LIte8p4koajP/2y2/p7EU7eGk1i5NEh/8iOIMBBZTM9vQTlyHA4kWV0g?=
 =?us-ascii?Q?GTPy+DcWA6z1Q2BBL68Qhk7UAZsjmz5ru1SjzJGJ0N54BoCSGwFfVQPJe0IR?=
 =?us-ascii?Q?DPzfo8sXoBptYqSIEa4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8676fb36-0964-48e2-694e-08da5566ea1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 22:22:52.8698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gak1Su4/aLrTPLoHQX5DSQtKPSjalqucegjBN9Vb6pSPguTJwlvbXojrcgTUhynAtOgbD1REn4cP5g5mU3qzgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

>> +static int __init snp_rmptable_init(void) {
>> +       if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
>> +               return 0;
>> +
>> +       if (!iommu_sev_snp_supported())
>> +               goto nosnp;
>> +
>> +       if (__snp_rmptable_init())
>> +               goto nosnp;
>> +
>> +       cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,=20
>> + "x86/rmptable_init:online", __snp_enable, NULL);
>> +
>> +       return 0;
>> +
>> +nosnp:
>> +       setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>> +       return 1;

>Seems odd that we're returning 1 here, rather than 0. I tried to figure ou=
t how the initcall return values are used and failed. My impression was 0 m=
eans success and a negative number means failure.
>But maybe this is normal.

I think that initcall values are typically ignored, but it should return 0 =
on success and negative on error. So probably should fix this to return som=
ething like -ENOSYS instead of 1.

Thanks,
Ashish
