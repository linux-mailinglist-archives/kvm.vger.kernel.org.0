Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCC58F40D
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 00:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiHJWBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 18:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHJWBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 18:01:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EDE75383;
        Wed, 10 Aug 2022 15:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/HIMreSVw7VccGmgokRAUMsTbLZOOE65tg/5agEoB6jxQRa0oxC3lZiXP/pcNJt4P2jUXSznUD2AJyAVw920iM4I+0/WTzU1D1B8sFKLopVJvFqpYP4LlV2rB1buO1Ymh7XHTBIkcVWR2JFc/0vXw7LLodu/YVGjUoilP7LJQay4jZpX/g0aL6x0n4cjXGni7vYoGyCuCL5EE0MDuVOeNSNhTHEQKsIPz1OoRcr18AfmAcAK67qmoxQLY+EbRtf2IsQ/Uk93VIetEj9FY2SizfBMNyzx2b1j4rwW5i/sd2pxMt0duevuWIhkmCxAcSgP0XkkhvWaNXNXGKeXl1Biw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+Ob/J9ZqjTLEI83b2M0E8Ga5wwOCgL/H6UI4F+W3UE=;
 b=JGgR+By4VR/ikYcoq7TuhYfFJZ/CpWWoLAxCREqr2z1r45dxrmtTSa4mJlmcGkOZWKSq9mcie0DcS6t1ZhbOdCp4K0FALgISQ9Qyj8yuQXeQ8pCNBPZZtuy8kiBeOhwmhnUdCgZ0ptsiXM+agxLXjcPp9LM9mMyJBaDbneoxZNbxMJzj/4P1UqUYcHfRAgpxieyyOmCYrD9yPChb3Zs+O54EKn+xpHq6sTNt2Z4ZHco7ZszcnHkUDTpQo2N3mA8iX9flEr5QYyCs6BltrH3l4/1GvXy01MGFociZTEUtqazXovqDCRuYB4Ei5eFEuv6u8nMrclGdqXF7/bs90z6jfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+Ob/J9ZqjTLEI83b2M0E8Ga5wwOCgL/H6UI4F+W3UE=;
 b=zTUJNMt2lfvxEpamjLsbOyDJa/tOHc2GnROE9qmPHgp9PWJAEsLlnB3A2YiEN/g7gEv6YszSyvTNEkcvGbnw3CqgWwyzf1fcuaco3MdukDV6Qqxn0dbgXLQ09aHiwb9JE8+TSg72HXDcjHEv8F17R8HxqWZu6t8LBXlGY6MIYaM=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 22:00:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5525.011; Wed, 10 Aug 2022
 22:00:57 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
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
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8A==
Date:   Wed, 10 Aug 2022 22:00:57 +0000
Message-ID: <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YvN9bKQ0XtUVJE7z@zn.tnic>
In-Reply-To: <YvN9bKQ0XtUVJE7z@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-10T21:14:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=39eeec9b-b36e-48b8-a410-dbbaae721fe1;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-10T22:00:55Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 961b4e90-7d6e-4ea6-8fdb-8dcc54a590f4
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39aaeda1-a224-4c4b-d061-08da7b1bcdf9
x-ms-traffictypediagnostic: SA0PR12MB4382:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XNKNOYM91dtAh8hDHQdL8HYnXt7pY2Y55Z8ToyP3dJ1UHBv2fOA7Nkx2KDA4O06I0hb2L1rr1k1t2fHJh0c1/YXDDeFm4AhTSWG1XGj2C6/kITels8/VgcN9vFNPgB9+YWbWqhLN2UkAsUk51seMalFW1nKYbJEKOpfPu5GFkkK2XXodlVNNPOFMtypp6KKEMAIyVgO3pYvASEbxeaAjh4snrXQWZffTGkSbank7+3Ubu8ZJm210sgFJleOotFXixjM3zGQRsJcxDD+oqwLn62cYYIXN8dT1daN4bBWUXM3zuf8clcMKfLfibNZXcqBPK6xO4WYoGrOypeJsm5nBd19M+jMMMaMNKgJaVhgtP//v48AWsE+VXqlLpRAu3w96SnLxq7u+F46gC2hzgVo+Gc262NAAaFb5K86BBBpih/jXcBXR0WP786nO/09CNre7lgqJQa2IewZev5g9d1AK/e+kbhUWeZp4Ei8Lrc6snu5PJKSxWZC2x+tOojI+FzZ6K5W3YB5gO/5ZZZK4hXUI51Hk+jlt4AKUZx1rPb9kQfFHfIQDQ6r/ZRKvgCKArKe34UvJ8MBBKWIPhcP4ta7k7Qzcnqyr7Slr1IJGCxNXuVvBzIsOViQ2IsrSlIm/S76tmV1Ph88QpAldxamcNoksLBf1YpuIR2Q04Q236D3KJiPpceBgC2OL4amwvzRV7LzhZWTBap0/NbmxUup2IGVV0IWSwg14fxHWZ8Uww5ofPmwOCN9fqjWp3vJeD9kaNe2wcGAf8ajfMdYC9jPBEFgkRMrTTdNq/bpQE8VW2ylgBzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(66446008)(66556008)(66476007)(71200400001)(66946007)(4326008)(38070700005)(6916009)(8676002)(76116006)(316002)(54906003)(64756008)(86362001)(5660300002)(186003)(7406005)(33656002)(8936002)(52536014)(83380400001)(7416002)(7696005)(6506007)(2906002)(26005)(9686003)(38100700002)(122000001)(478600001)(55016003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DBGKUm6/yuC27IFtl0LuEPRbF6/PbIWZF57DqcQloPC0YBGbk3v/v90VcHLq?=
 =?us-ascii?Q?rP64MujOu+H0WkYjDdpk23IZPgwcNrJ2bqBgHAEHqTQtw6fzlm8GlHVD7R98?=
 =?us-ascii?Q?8ueUGgyoGQ0AlfimAbh5l0Kyw2oWPLUtMlEhv5Jp1E2GD020dCq3gID1OsIN?=
 =?us-ascii?Q?W0DRyMbs3nck+pDoT0e5Q0Oqq48XicbLzWTDtxh13R4YMilwo+HeRwWdBJfD?=
 =?us-ascii?Q?0WhcP2kWd3ebwnRs8J8bLlxPVrcSdjyLcMaH1A4gk78CLGCtX9Zy+Zq23j+I?=
 =?us-ascii?Q?ZssagwrbE/Ic6bAtbhZ+0Vk/0s7hLtvTxc9QlmI4DNKFVSxmodxIcgaVcRi8?=
 =?us-ascii?Q?1u0CzDEgiPUFCNY0Da/4YoozCVrIplASjBGQPqkRfL8canKoz5HFs9me+L5b?=
 =?us-ascii?Q?ElRFRpGNcsENdiSfCEW9tPCNxRtj6vNpYtEElYpDKXELOpmRMx2ZlEaG6FjV?=
 =?us-ascii?Q?0NiMQ+EW5YK3iEH2XzrE3C7ZlnilbLRRjIsjfVXxkrJWybfpgGJbxNgRW4u7?=
 =?us-ascii?Q?on7xBNZKH9yPwXhQJ/Q57Trr9lIPHsnogyYJXa5kqOGOEsbbhRxGaHO1nZ/S?=
 =?us-ascii?Q?9sOtzxVaArfj4QGPtJ0qhWFsQfDplfS3OXqyI0cl295FXmjlpZHXSqopj90x?=
 =?us-ascii?Q?DzsrtmE/2PaownzyoKxxxB4W82Mo3hOEx07UWRUwOCWRsNpKN3HGOqGN/zMS?=
 =?us-ascii?Q?T4L8TUC/jRuOC9aT0oi0bxZ8ZOIjCfagu7LBEoqw7UcYh/CiY2hoZxBQaHmH?=
 =?us-ascii?Q?jvS5id8lP2mEwhynGKAQXZhFgKMcXC6gSApOKH0kO+CvM+RcioUZWMxJnjYt?=
 =?us-ascii?Q?E01T+nTN1w0wb2Z1244zVx2EnKt9ZZTr0wm9fqLz8WCWCG90psd4Agb8izud?=
 =?us-ascii?Q?6BZVKLOAiwInY1kywR2Rjm39CEIkFsyWcN+0VEQOLuHsfCCpCf5kUWQHjHcd?=
 =?us-ascii?Q?+bzCYV0kD47opkE+TL00RSueG3kCpIFjTAQdN2Alm/nLP7+VOQx25ANjQDOB?=
 =?us-ascii?Q?vkgzgCNs7CY3HKHctn/hkFc7kP8B6UzNzX7wo3s83OA0geLpHi+221AANebw?=
 =?us-ascii?Q?24HmTkf5xKXi+MizSDYB+PmUdJJwMe6pUGHaHLkfjB6FK74VBt81fxKel0Ck?=
 =?us-ascii?Q?FVqEk7rv+LHGCQ7RS1J5YCScRqsr7omFo3l1rCQauXKZ3oXUQNfoyHJqIBiC?=
 =?us-ascii?Q?3EH2ivWFMKUqDIR0ewn58JxhRb8ucAT+55h2nog8/G/K3vwlSJrY3vsCuo0H?=
 =?us-ascii?Q?c0K0sWDZsBJkXZVbvVCKrdJ/WQjb/F27kXa4RfC+CYv03a7PM4uuXdXP4sGe?=
 =?us-ascii?Q?4JGnP1DwIxudPDLYeuUsqeEKmQbR3uNWLd/9WgNuoIjIUBeMcTmdumHQTqgP?=
 =?us-ascii?Q?40SW1iYCtdQ0vaj7tFhYL6U2+EtD1m34iW//dNO+fpIpTOa614FpTVOqo4gs?=
 =?us-ascii?Q?0MLPMd74p5ELiZo1MXTmqoFXgGggH6YnL+18or9xDJObXO4vvGO2N5/tvcSS?=
 =?us-ascii?Q?fkzHH7TEHHjYXjEZbPVlWE0qvyz2DeP8xLzcsNvy/40NGkiV6uk7uzo7EEiT?=
 =?us-ascii?Q?PlQA2lga6zwh7qMRYpU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39aaeda1-a224-4c4b-d061-08da7b1bcdf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 22:00:57.5756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uPEFhntQ0jnnQpl2+X+pkQgxEYZ1r309ZCktccAeoLkEZxPRr96kmokOAjHZx0nzBNDThT438UIhG03XdrzCEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
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

Hello Boris,

>> >You need to elaborate more here: a RMP fault can happen and then the=20
>> >page can get unmapped? What is the exact scenario here?
>>
>> Yes, if the page gets unmapped while the RMP fault was being handled,=20
>> will add more explanation here.

>So what's the logic here to return 1, i.e., retry?

>Why should a fault for a page that gets unmapped be retried? The fault in =
that case should be ignored, IMO. It'll have the same effect to return from=
 do_user_addr_fault() there, without splitting but you need to have a separ=
ate return value >definition so that it is clear what needs to happen. And =
that return value should be !=3D 0 so that the current check still works.

if (!pte || !pte_present(*pte))
                return 1;

This is more like a sanity check and returning 1 will cause the fault handl=
er to return and ignore the fault for current #PF case.
If the page got unmapped, the fault will not happen again and there will be=
 no retry, so the fault in this case is
being ignored.
The other case where 1 is returned is RMP table lookup failure, in that cas=
e the faulting process is being terminated,
that resolves the fault.=20

>> Actually, the above computes an index into the RMP table.

>What index in the RMP table?

>> It is basically an index into the 4K page within the hugepage mapped=20
>> in the RMP table or in other words an index into the RMP table entry=20
>> for 4K page(s) corresponding to a hugepage.

>So pte_index(address) and for 1G pages, pmd_index(address).

>So no reinventing the wheel if we already have helpers for that.

Yes that makes sense and pte_index(address) is exactly what is
required for 2M hugepages.

Will use pte_index() for 2M pages and pmd_index() for 1G pages.=20

>> It is mainly a wrapper around__split_huge_pmd() for SNP use case where=20
>> the host hugepage is split to be in sync with the RMP table.

>I see what it is. And I'm saying this looks wrong. You're enforcing page s=
plitting to be a valid thing to do only for SEV machines. Why?

>Why is

>        if (!IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
>                return VM_FAULT_SIGBUS;

>there at all?

>This is generic code you're touching - not arch/x86/.

Ok, so you are suggesting that we remove this check and simply keep this fu=
nction wrapping around __split_huge_pmd().=20
This becomes a generic utility function.=20

Thanks,
Ashish
