Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD6553949
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245083AbiFUR7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiFUR7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:59:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8981C107;
        Tue, 21 Jun 2022 10:59:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWlMl1Zv7V1KqfZwdmnZn039r6lDoVW+3YxVwVdjLzU6c3W/bbMnjP7/DqLHhbnSRV+9RlhKLwxytAyBSM0cbtFvk8orFN7m1IjEW4Q/5h5NxhKR3MusGiohltkTNXEATmoNUjmb80iGcseQkF+IE8QkFBBAdQYNUDDQvCnHTrxEueIb6omDTgK/MmwhGu6zH7zkBohqS5NYIwY5Bl3zGn11sNoUgILBvGs9Otn6Xwr6BhTmtpkVP1ZOHXTghOcuZYR5EEb+8abgo6wECiZv8TBXr+ohVNz7j0Q33dN/JSqCKjLqDP2P7kvHOD38k6H00Pns4cpgY0J4foYPiACBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edJ85O1jFo73jZ0Ls/MVmFOX6+YXFL2AXd7oBT6PFt4=;
 b=WXxwJcqx4KAsTaDxwb2XYNaJEm/iR+sYxRRM3hBFMFZSXuXZcprDQcTSEeo9AZMa1Yh1JPdnmt1xFwTfmW10/UZe2E2sfq9pKJ1nlXtmOksVuLh2/z/ywBwfkObgHrDMfaeAkFg/sFLn0a5wkE9BHfRJOELQtqNIbJ6NHMR9GYpAPzTGwjFXmLNedAtEwDVE1o7mSyO8G7g6QKOUunTN8JUKfKoz9JqM08rSguDURsqCn1/OzNTkELBemb2qs5H6YJqU7fH2Z2p8QsdvG99jiMUcgVmkbothirINsjL3vSWT38URk+wv9kmsmbKk/HIdp/7Sqr2VgU9GQjfYKZ6kZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edJ85O1jFo73jZ0Ls/MVmFOX6+YXFL2AXd7oBT6PFt4=;
 b=sVfbrKgiF1fEmssvS9HeWKj1UbKtCwggDVJ0lEQr4VOC1YF+7dWNAPV32PTyes82dSdqHZT8Yuix1/kYAFd1HejkfI6a1/TlJfjCZ5ObtdG6FqPRmYEGdDumrGQ0Bn3p6kvcyjpMhh5NNrx+coFz9ppxMBSOIRi2oK2DGjzsBCY=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CY4PR12MB1909.namprd12.prod.outlook.com (2603:10b6:903:124::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Tue, 21 Jun
 2022 17:59:44 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 17:59:44 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Sergio Lopez <slp@redhat.com>,
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
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Topic: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Index: AQHYhYYxcxQqbwBTdUCpGH+ovKgAp61aJTcA
Date:   Tue, 21 Jun 2022 17:59:44 +0000
Message-ID: <SN6PR12MB2767C6D128C991F86B40057C8EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6qXSMf5zadv+rwHUp5hTHRJQzi66fJYEcU0QpMg1y7aXw@mail.gmail.com>
In-Reply-To: <CAMkAt6qXSMf5zadv+rwHUp5hTHRJQzi66fJYEcU0QpMg1y7aXw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-21T17:59:26Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=110e80eb-0033-49ed-905d-05641f40527b;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-21T17:59:42Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: d65cf9a5-df54-4d0c-b4ca-13a9728b3690
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0c8f321-0253-46c0-b5be-08da53afd2de
x-ms-traffictypediagnostic: CY4PR12MB1909:EE_
x-microsoft-antispam-prvs: <CY4PR12MB19096BA3AD3A989ECE69D73C8EB39@CY4PR12MB1909.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qfdCfvefmxIh0h6jXQU2ZTl7fPPd4Hk4v6KXIWarvp/WiZDhrjDRd17tPcRBxi3mPShQRqerVt5lJLY8or2NYq81fKSbnR9kUNR86CZjx9dA4afteld99UV3Y3sKNouRSRW7rjng6AZpIrltH1Qiztb9c9R3Us/7ivzv35/UXyJG61ZtOUN8hvAv074TVhZLo+OaDu9DszsCzmA9l16zNdbk8BUqRDQLGKc1VnZiynWSGnJmCBNKM6IG5MC+K9X4y/HLAsG485o19Nb+opZRA1aGqz+hgzjpgWLzgs43Xil7rEOwiJCgE9AW5bHFUl3Zl3ubmhkifSFhuHk71a9ySMEVz3lJshAcHr2BdNMg7Nzk2Ox34PGXG94NzCqoeVikiCawhpapeuiT2LhOpwL2pwKZYDEVGReQ2Rjr14Bo4EzRPU6/6J+8XZf/9eaqcb5Uu0TpMMbCYZKGk8I12E2/n7zAfB6DaH6z6URZjN499rGb36+NoCEFZFXVMsCY42z2L4SAg5fbYs/LtXTVYW1UKj9iDFNhzq/XolA3A/BhaZBcmtnPZLGmzDe7OtVT1MqbBe5/6wNkg61HfjJYrY5QtSesHUdNKe4AA2MJO9Hv7qOypEgx2OZFI9HqPjuptM7MYv3I0gnACRMuQBzbXwScnaEZFR0FeemOcUxLC5G6ZNCo1KDRjF0cb2o86c/QCEOzJAuB5j+lnaYQY3JIBmJ7AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(5660300002)(316002)(38070700005)(8676002)(7406005)(122000001)(38100700002)(7416002)(52536014)(8936002)(71200400001)(54906003)(66946007)(64756008)(55016003)(6916009)(66476007)(66556008)(4326008)(66446008)(76116006)(86362001)(478600001)(41300700001)(7696005)(2906002)(6506007)(9686003)(33656002)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmhUNUU4emlsZHlTOHgvaXM0cFFhSWZzcWRHNHkvYTdKV3Q2WDFiQkM5Tk0y?=
 =?utf-8?B?cDhLSnRJTCsyZGUwcmFiTWVpSmJyZG5kUVBuZzZneGViMXN1WTYzNFlqK1VD?=
 =?utf-8?B?WmtQeXRUSzBPWkkxY01OTXdORkhMeFFOZ1BBSVJIV2UzS3k2M2lxWUtRY3JX?=
 =?utf-8?B?WCt3Um9TZnlJbTlTclh2SCt2dmhaTXh6YVRwelVaeklHaTMyVitFZnBjbTVJ?=
 =?utf-8?B?UzFMWThWdzZ3SlhZS1BrTUxVbDJZQWxPMUVCNCtXVUlOMkkxNVBJaWZIM0ow?=
 =?utf-8?B?K1lRbzNWQzdDK2FGMXFXbkdpMVh4R1llM1pXVUJhcExiZXdPdEwzVEVQRkRQ?=
 =?utf-8?B?bGVTZGQ0bHMzRlBkVDNvek16VkZIL0o1QUw4T2IwaW55WC9zSzNpOVFHK2xW?=
 =?utf-8?B?a3lDMDlnQWZLMitnMzhZdFZ5MlpScUhYY2hicnM2M2hmbGRIcmpIWmF2bFJJ?=
 =?utf-8?B?QlRxSXE5NXFWRGl3VjJQS1R3ZndUOXNvY1lQbjRSaERMajZvV3o1aVIzSU44?=
 =?utf-8?B?S0xMM0U2Z1pYbjI4UmJUUzFOd3NrM2FJYnhyY20yRzA1cHF2ZTNMaVhEVmhv?=
 =?utf-8?B?dnFPeGZRVm9BS0J6N3hrZTBOSjdBUmpVY0xNTk54bVc0OEtHamJhSURyZmk1?=
 =?utf-8?B?dmVEK0diNkNNNkhPem4zNU91YW94dE94MWZGNlNCV3loc3BSeFlZK1cxSEtN?=
 =?utf-8?B?WWFSWlVnZTlFVjJ3MGdmdzlvNVNpai9ycEg1Zks4K1k5OS81dXZxQjBhOS9D?=
 =?utf-8?B?Q1BpQTVwei9WYkNrWE9FWk1hRXBBS0NuV0o4WXJhTWNRZVl5VUVxMk9HdExZ?=
 =?utf-8?B?WXZsMW5laVZSbWpGdGo1L2pZUkdQSENPdE5ZSEVKNnd2SnR4bzljNEt2SXJx?=
 =?utf-8?B?ckRnb2htNVFzaytlVit1Tnk1aFlKajYvMVVXMzJxVWxxZ3JBb3JDWjN6dk8x?=
 =?utf-8?B?eHVac1Z4RTBhV0VDSlhMTHVwS2duRTVoTC8yaXdPUFBsODdpVW5KUEtBQXJs?=
 =?utf-8?B?TjIrdzJPWlQ1K3hJdk5MbjNEdlA0SlFzbGFlcjNOT3JvRzkvbCs5aE55MDdL?=
 =?utf-8?B?WXFTOE1oKzdmQmlHN1JUTVhtOFQyOUIvVWExSHdXSlpyUmFUeGxqWjlGd3c4?=
 =?utf-8?B?WVovamdGQWpTeitSdGR6QXdjQ0tGSVBjQ0YvdUkwZ3laVzBFY3U2czBVQ0w1?=
 =?utf-8?B?SXJtZE5KYXFYaEVNaGQvMldyQVFHWE9MT3VDMkRuNGFQNXNqaDdpVHpkK0FI?=
 =?utf-8?B?aFF5R2hMTTlWZE5xWmNuV2tuTk1GUGF0bWtBZ3E5cFk0dFhDOWo5QU9UMU9j?=
 =?utf-8?B?MWV6M3ZHdzNoWURSK01zaFplRXhSMTZ1bzFQQXBadWNHTnNEMXlrakRyRmR1?=
 =?utf-8?B?dkZQZHRxNWErT1gvNStFVlNyQ0RFdThHdS9YQnBzRHZZcXR4amhtSFZja3ow?=
 =?utf-8?B?OWNtK0JJMytwQndOK3I1NTgzSDc2ZDZhUnRHMWN6N0F5STNXL2dUOFhEdFky?=
 =?utf-8?B?bmp2QU8rNDdhaWZHRFlvdXZhbGlzWlc2OWF4TjFrTHducm13cnZkdU1xbVUz?=
 =?utf-8?B?YnJkTURCUWhTWldISkxFN3gwMnR6dXdtd1h1Q1AxSTVBV1VHZUJlQ0wxR0tO?=
 =?utf-8?B?S3ZacldmRHVpNlRGYmJqS1NYVzgvU1NMSUdmQlpoL0phTEpSWWFSWnh3SFlF?=
 =?utf-8?B?dHVZU3gwQjYvMjlja3NvRkNmQmE0SUUrTWhjcTZtdnBEU2NvbEhBQXNINE1R?=
 =?utf-8?B?cUw1d3N1MEwwSHg2NlRsMlhJYXpURmQzK0x6dmRhcGFhR3dnd291S2pReGRF?=
 =?utf-8?B?VkkzZzltZmdidFFEQ29WZ0JLQjlOTXZySytXQmhZMnpzRHlqN01lK0QrTG5C?=
 =?utf-8?B?MjNFS0trMzE3Y2wycXJBZ2FCWlFtT1ByelBjRVlEdmlDY0JGTzZoUkhua1hm?=
 =?utf-8?B?UnVhR3M5ZUVSS2lkWS9Pd1JNUWdwSnBhSklBODY5WkNxWU1xbHNWWUN2YVFu?=
 =?utf-8?B?R2NMZmxFelgxQ09kbFo2RDlFeWxVZENjRzRDSlladkcrTWVDbHk4MlVJL29T?=
 =?utf-8?B?SUNkQ1UzM2JJRS9pNVpFWkNQZ2FmL2VOSmtNN2Y3aFFuVXl2eEJwSDZtZEM4?=
 =?utf-8?B?eHg0c0JIS3FQdUNUcWZhaFR4ZWZscXAwREUxdGRUYTBJRm41NTVtQkE2SW5w?=
 =?utf-8?B?a3lycnpVMnUwZ084QXZCYzdzamxiM3l4Vjg1QmU5SFpFUCtHYVJCN25iaEla?=
 =?utf-8?B?WTVtZHZuMUUxMzhXN1R3eklxNEIxNWwxWHZDM1VSaDg0SFlDNjJKcUF0MEtX?=
 =?utf-8?Q?XCSkQ8AE+o06OGJkT2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c8f321-0253-46c0-b5be-08da53afd2de
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 17:59:44.8070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wHDKTUXKijwCllJ+FtARS0m0+vT0lrNjFdtMnKpJpQaXowq8UUnzEhUoMkos6WB0ZmeuwGVc1n3EXZ7MUdEjQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KSGVsbG8gUGV0ZXIsDQoNCj4+ICtzdGF0aWMgX19pbml0IGludCBfX3NucF9y
bXB0YWJsZV9pbml0KHZvaWQpIHsNCj4+ICsgICAgICAgdTY0IHJtcF9iYXNlLCBzejsNCj4+ICsg
ICAgICAgdm9pZCAqc3RhcnQ7DQo+PiArICAgICAgIHU2NCB2YWw7DQo+PiArDQo+PiArICAgICAg
IGlmICghZ2V0X3JtcHRhYmxlX2luZm8oJnJtcF9iYXNlLCAmc3opKQ0KPj4gKyAgICAgICAgICAg
ICAgIHJldHVybiAxOw0KPj4gKw0KPj4gKyAgICAgICBzdGFydCA9IG1lbXJlbWFwKHJtcF9iYXNl
LCBzeiwgTUVNUkVNQVBfV0IpOw0KPj4gKyAgICAgICBpZiAoIXN0YXJ0KSB7DQo+PiArICAgICAg
ICAgICAgICAgcHJfZXJyKCJGYWlsZWQgdG8gbWFwIFJNUCB0YWJsZSAweCVsbHgrMHglbGx4XG4i
LCBybXBfYmFzZSwgc3opOw0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiAxOw0KPj4gKyAgICAg
ICB9DQo+PiArDQo+PiArICAgICAgIC8qDQo+PiArICAgICAgICAqIENoZWNrIGlmIFNFVi1TTlAg
aXMgYWxyZWFkeSBlbmFibGVkLCB0aGlzIGNhbiBoYXBwZW4gaWYgd2UgYXJlIGNvbWluZyBmcm9t
DQo+PiArICAgICAgICAqIGtleGVjIGJvb3QuDQo+PiArICAgICAgICAqLw0KPj4gKyAgICAgICBy
ZG1zcmwoTVNSX0FNRDY0X1NZU0NGRywgdmFsKTsNCj4+ICsgICAgICAgaWYgKHZhbCAmIE1TUl9B
TUQ2NF9TWVNDRkdfU05QX0VOKQ0KPj4gKyAgICAgICAgICAgICAgIGdvdG8gc2tpcF9lbmFibGU7
DQo+PiArDQo+PiArICAgICAgIC8qIEluaXRpYWxpemUgdGhlIFJNUCB0YWJsZSB0byB6ZXJvICov
DQo+PiArICAgICAgIG1lbXNldChzdGFydCwgMCwgc3opOw0KPj4gKw0KPj4gKyAgICAgICAvKiBG
bHVzaCB0aGUgY2FjaGVzIHRvIGVuc3VyZSB0aGF0IGRhdGEgaXMgd3JpdHRlbiBiZWZvcmUgU05Q
IGlzIGVuYWJsZWQuICovDQo+PiArICAgICAgIHdiaW52ZF9vbl9hbGxfY3B1cygpOw0KPj4gKw0K
Pj4gKyAgICAgICAvKiBFbmFibGUgU05QIG9uIGFsbCBDUFVzLiAqLw0KPj4gKyAgICAgICBvbl9l
YWNoX2NwdShzbnBfZW5hYmxlLCBOVUxMLCAxKTsNCj4+ICsNCj4+ICtza2lwX2VuYWJsZToNCj4+
ICsgICAgICAgcm1wdGFibGVfc3RhcnQgPSAodW5zaWduZWQgbG9uZylzdGFydDsNCj4+ICsgICAg
ICAgcm1wdGFibGVfZW5kID0gcm1wdGFibGVfc3RhcnQgKyBzejsNCg0KPiBTaW5jZSBpbiBnZXRf
cm1wdGFibGVfaW5mbygpIGBybXBfc3ogPSBybXBfZW5kIC0gcm1wX2Jhc2UgKyAxO2Agc2hvdWxk
IHRoaXMgYmUgYHJtcHRhYmxlX2VuZCA9IHJtcHRhYmxlX3N0YXJ0ICsgc3ogLSAxO2A/DQoNClll
cywgaXQgc2hvdWxkIGJlLg0KDQpUaGFua3MsDQpBc2hpc2gNCg==
