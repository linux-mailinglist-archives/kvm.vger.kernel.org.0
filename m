Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA06D553904
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352147AbiFURij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348113AbiFURib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:38:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7771A07E;
        Tue, 21 Jun 2022 10:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0A+MEhhW7YNog6lwU4sQTmxp9X9JM9XzkxzXJ3x8egT8Wmz7Pb7Pk3y41IEfLhtAoVhrb8S/QL24P8v+2srgh8rttupn+8s/A1kFtGVThvYEgW7rB0h25XIAAI8TONbwPooj1Jq+6lV3dehXOnmVjP1oO4AiHfhkZOm7DUvZeCfNDEzc62ZYtCDfT350xC/OPphwgY3ZyppwK+MxhXoxC0VENuCGrzn4Z6WITZM85cdwuu+XnHP/NfyrxHOc9w11Ir0goXYY8LzoJCe0+m9deWeM1baaQFVAO92lVyM67sbL0OP5sBRRVKuPrs5JyT0fvCtSXrVlr3j9gKJu8nTJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaIpo17dLAMwr8h7a8VYtEcOxLWk+5NnYRRKvWSjzJw=;
 b=mjmHsdsVj2x6BqKzKn4ekchwTBgoPqpNjhY5yXxjBFOdSiEYOgYL6SHq2+kKQ8jF9NtR7MrZZyH+eSflJ0jmKp4ljiOJQ8pXh+YTPBp96nMgDT4AXNecfR/hBFXt4zrELAOF0XbXvoeOypswWYOFWCcHB1hpzUlCg3Hoygzl2UYy7yrekXToWPH93/Y1dB1Ee9jflHxPDtsKjRPybx0zQ7JaJ4rDvQRy0oYlZ5mcXung19+quk1CjaGpY30xWLpW9fjCYHtfb0d/x0Noey8lUJz8GKcR3nObFN1feNQBpR8+s493bhiwRrAPOjzhoSSowfYmroiu/9zP1nNzTcVVKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaIpo17dLAMwr8h7a8VYtEcOxLWk+5NnYRRKvWSjzJw=;
 b=QZroztkyC4FT89LLI141rI6rq7QpgNsl4Exf1o/FYHAYdXJ1tHjC4DotBCOTT6pzpYEkofV2A1n6pAm6sdIJYdaZC1WC+1WluuZDwTa40Fg22cjLEqir6Idk+x2w5ufSPq8xmdY0dbia/GIzZvB7tpV74ldWbVqXkxXBfpht9Fg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MW2PR12MB4683.namprd12.prod.outlook.com (2603:10b6:302:5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Tue, 21 Jun
 2022 17:38:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 17:38:27 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Topic: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Index: AQHYhY2kulHh/HmbIUq97K70l/FApa1aH19Q
Date:   Tue, 21 Jun 2022 17:38:27 +0000
Message-ID: <SN6PR12MB2767FBF0848B906B9F0284D28EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <YrH0ca3Sam7Ru11c@work-vm>
In-Reply-To: <YrH0ca3Sam7Ru11c@work-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-21T17:35:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=8ea0a6e0-a48a-4e19-99b7-56489206fe63;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-21T17:38:26Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 3f6fb533-368e-4e71-885d-16f14872b445
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 418a90d3-c75f-4ef7-4557-08da53acd987
x-ms-traffictypediagnostic: MW2PR12MB4683:EE_
x-microsoft-antispam-prvs: <MW2PR12MB4683C4B1E10D81E4B5BB414C8EB39@MW2PR12MB4683.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4YVMuSVkn6PH8+z7881ciImAknVU5PZ45V7kNXSzFuwsmkg9QvMsGqhr8mHLJ9P7wzsPwnAOrfK23PDKuqOcOF05MuRkUH+ly9D6mFyc7wTBBz5CXXCPZx4cPT/tKUowI2+G6tBQcEsS8prTl8StZUszg4tbLmgD6LV4mKoMm6GDhXylGaCzJLEScks4f6u1Tm79niIvRP2mnMufKSeO2mDoW3VshlwKvtUG9O6tyTiK4N1LiZWXKAhXy1KtxqaP+X7scr74ZQXGsQn5J3eywh3a1q/ETa8jtfe13mKOGX6VWEducWxKeMhaQlUR96kVlTeP52n+BEEsqI/qbuK33l0OyZerEuUKmKtiKuyprRpSS9MzgoRfJly3YjH9/VH+o4vWGvv3F45J3547RhtoVxguue2pHPnh/egAH28mSItYLDwjDhIC74dfbPHNBUvxFe9zaxqPHUzbPhtdigLJOpzsY13WjAAgxchTJVoqXwc436Dhbi/bwbSqZNLSf+JVCFPpIvESs148C/5sE4WjN8Xmc+lSvH8+PuZjgK4IJRIW4OS2BXICDDvlMnaSAlEELTYJj6wsNrEwqKMiBSvvvkCRNRA0e7lYN3W9Qi25BeAH66reTtfllG5FRyh6TfWKwi8clNybn6Ylv6ws+lbCbAk6iTju6qwXuaJ6pmolSLOlk2mNw7hXUNzI3cV2NNd3NG98nAv15Xq9+kA39rW/ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(316002)(6506007)(186003)(7696005)(26005)(2906002)(41300700001)(6916009)(38100700002)(38070700005)(52536014)(71200400001)(64756008)(54906003)(66446008)(86362001)(33656002)(478600001)(5660300002)(8936002)(66946007)(66556008)(76116006)(4326008)(7406005)(83380400001)(7416002)(4744005)(8676002)(55016003)(122000001)(9686003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B3cBM4Pdtv1/wK5rr3hIZwx4PY7M0a+WJm8buHcC5sYUp9HlkJLgVmAArqxO?=
 =?us-ascii?Q?X6BknPQoRUgNmujGijhGVR+PHYwZnAQp1TE8jxHTRbcRi8Bg9E6q1vnpddq8?=
 =?us-ascii?Q?XNZI3Cxo2PKoQ23JMJ3Zeyqvlydq/8t0qxjhbbGN42Sr9xNAxzUfVcH2Dryz?=
 =?us-ascii?Q?fuVpvyVwtYEYsUBCaExmHR8FyyQik2EBB++tXMRShSpXLmFG5ku7Jnqiikjx?=
 =?us-ascii?Q?1SMwvWsEhD4yGF86eeddyTHMbUbw5Fsm12wBl8I9nHyc7j5oHe5b2ReASDUI?=
 =?us-ascii?Q?C0uTPU0075wjVwGI/BJYQKRgbjSsC4NWHw0X6se//ewR+XO7qeHkuXP/NwCV?=
 =?us-ascii?Q?LM9TL9708e7Hjxlus5rCeWQspAHsKYPc4fFu+XI6HawUTK2MUCpJWb6EsIFN?=
 =?us-ascii?Q?Law44bmHHiXBDfHo1iYbcAsUgTiYnZOxNEotvR2ZYFfbvpVKGVcErn3zjtj1?=
 =?us-ascii?Q?FMcPI2s+Z90jwu03HMl+fBJ+0uc8bWr0UXpPAR+17JIh+NVtzbKarnLzV5a2?=
 =?us-ascii?Q?hanbbp0Umg5nzlgXt0TOW0IXIh8ybYHY8DBOYTwBSGjqB45a+n0lBbTvtgG2?=
 =?us-ascii?Q?dmHIn8m9ykG1TEIs27oPIgSoP1EkWvezOFpp2BvHWUaTlEFFQPaZKq0C7hgP?=
 =?us-ascii?Q?5X5oNpynk5V0fef0pGkIOJBa2t5OKgntNYL+gfQOLeAYOK+inYbvABOt9YgK?=
 =?us-ascii?Q?rjZSWAXKsEI4xV70kujSZZEa9Ia6Wpzd3MbpKnUF2h9SuB19FhuPgFcuhVQj?=
 =?us-ascii?Q?tw5/dUGX1Zc7F3UAlJbznAO3J5ChBs0r+T5K548B9SFzVVnNTnApnBclr5pi?=
 =?us-ascii?Q?Q5wGvdiAo/XIHiYc3xdoLObpFf3oOY+GwT7JkmXhLy0DISEjuJ8FAqHs752V?=
 =?us-ascii?Q?1kPNt5WsXhZ6mi9gCfzDs0aakK5pCoRMqFPXLEH6qwTKBz6pfQDoybFembcR?=
 =?us-ascii?Q?oJ2n61P7R2O9GFKGJd+Zzd/5eiufCLnB/hke9xLMCU4y8muOS2Arje8oVCTx?=
 =?us-ascii?Q?ywWsukEitJLG4MBpRK3aa8hU4ubmwS1SSMNSNkeyaynrFp47rPAYimpl0VLv?=
 =?us-ascii?Q?CPaQBaoJW7LaiCCLKElEqV+NpdsPq4rZdt19JW0147S72pZd00isDcFdbFx6?=
 =?us-ascii?Q?U2814RSjm0eeJpI11Rk4GoYloDjb0LKcBI21B/4hPN68e7oaMkxg1KtjgkBn?=
 =?us-ascii?Q?vdNbE/eCkUq2IO3N6NffyCLxhoXf1JYXpnMuYQrW6ZCFEJHfEEdTZShO12XE?=
 =?us-ascii?Q?AJFhJIjgluob1AlA4ZEw8HEShW/fEcVz7Iprak/mJElSmwoK6ancRNgvtcZr?=
 =?us-ascii?Q?7KSSwYORJvxLS1AqP5gLCutrDgaHXrnU65vOdyGcT4z/Ap8MQWUM8clML8Jg?=
 =?us-ascii?Q?ylfv7E5M6WlIYWcUnKEXMu+F+TtjKjh3bL7NxjSdqVc663rFrypMv2Q3ixtJ?=
 =?us-ascii?Q?nQepWflNFCszZirJz2h5ZzRDX+ziDFenzEm8l90EcO7Ade/DuvpKM5x756lH?=
 =?us-ascii?Q?hhWCIj7yQoyeIbgpXYR1RZbv9aCxkcRfe8eAykS9Tong5buOKR3eqFSghw16?=
 =?us-ascii?Q?/js6wTXxd723sxtkrSQJx22QNt4Wuvv7FbFZyWGUdU+y1JnMQ8G40MbqqRAZ?=
 =?us-ascii?Q?bGF9Psb2qIR4Vo6Q8Kt37XMZ3SA6UpHagOhf00iGqmmRxGSL++O0AEpYMXhW?=
 =?us-ascii?Q?7yAtwfWUh9EQCgWR8l/wV9K8cSpX4D96JwLB2pLO0appvmqi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418a90d3-c75f-4ef7-4557-08da53acd987
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 17:38:27.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oub5dhfnjkySLIxvVonfDMpuygA7kZI1s06fQ+SCAQZAMYfC+N5K3WeLuFk4yRjKn3nRzg5keMqAdpgthAooaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB4683
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

Hello Dave,

>>  /*
>>   * The RMP entry format is not architectural. The format is defined=20
>> in PPR @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
>>  	u64 secrets_gpa;
>>  };
>> =20
>> +struct rmpupdate {
>> +	u64 gpa;
>> +	u8 assigned;
>> +	u8 pagesize;
>> +	u8 immutable;
>> +	u8 rsvd;
>> +	u32 asid;
>> +} __packed;

>I see above it says the RMP entry format isn't architectural; is this 'rmp=
update' structure? If not how is this going to get handled when we have a c=
ouple of SNP capable CPUs with different layouts?

Architectural implies that it is defined in the APM and shouldn't change in=
 such a way as to not be backward compatible.=20
I probably think the wording here should be architecture independent or mor=
e precisely platform independent.

Thanks,
Ashish
