Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F413570D7C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 00:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiGKWlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 18:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiGKWlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 18:41:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AD052DCD;
        Mon, 11 Jul 2022 15:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKE+FMMZKVL6SfmObCAWf3IgnXA7AMhM4dBNtwsoGc2jNExn8xRmzWoAIxYfiMpGZK8hcxV4ZVpQHkfNpsu7zIjP9UUxJaia1afn7IdqticO/MCMvCaE2Vg8v5WfUJaNwvdZHULbb2p/7QG4gbppi5NJVtDjMC+qrQATcAMYl8NqpdJ2COZDuoRzXCkuMpknCeg18o8diY1qssQA4bDHn+5eRea+BSYtQ//pC2bIj3cTS8hUDsFlnE3QA1uoNOhk9AL7GBfrAcBC/p/cwjXArs7qWsWcTO+qokl8OUnDS0tBgmmfXlYoV60TgPJiKjTQk5VlNST/CyOW+B1yzfmzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtVpm/MxpE14sKaaNhhD1KQzVZFTzeDA+mZMpl/ND3k=;
 b=DB0Fz3iWszSMc2umwhzyw2XUaDXvy5hL+E+4XWhfi0gGYr+bIHzg59RdOH27FElSiUb5efH36zx3f4Pnlw6hZqz8OJqOy+NT8YTw7gsWgqLYEzVPKWAv7wU7iP5GCUs231Kzk1+dGMP33RIPY9ReLJjeNUvBe6sw1w+u3Mgmd6Gf+mLEBHP1yuacIcY8ecVFVf9mn8txQ2N1PBdW0o8N8okVUegt35rP81BuWW/tuKZkWvlPfddNfolJ3EpBEg1bR8q13H0jvCuJahdN7KOpRf+IoMt5+6jndEfwdSIcIzRT3/9iVpucSrbVQVcGCy7SHzM41Ong7mGk6k8EzW3m6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtVpm/MxpE14sKaaNhhD1KQzVZFTzeDA+mZMpl/ND3k=;
 b=YyRaEKwW1unGr279ht9YRif3X3R7FQF9xYbU6XvMgR2C5IojZQKzHh2XLRc44nlQn6vFIJ4uyY6jEI0oTSI2g8oj+6jU/vWT8pQgSOYJ0SUIwExBKQhCp2i6S7HM9573oy4Y/e4OWD8MC5VzI9P4V2w6hGfiOZK/Ddo/2bsGYvk=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5209.namprd12.prod.outlook.com (2603:10b6:408:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 22:41:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5417.016; Mon, 11 Jul 2022
 22:41:35 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
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
Subject: RE: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Thread-Topic: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Thread-Index: AQHYlS9F8Lv7wrs5NE6SmQ1dqRz5cK15oJ+w
Date:   Mon, 11 Jul 2022 22:41:35 +0000
Message-ID: <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
In-Reply-To: <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-11T20:33:37Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=c4c7b04a-7635-4db7-927f-1c57d5cc5f3a;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-11T22:41:33Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 2d22016b-3d85-4fea-9347-ae5b8e6bb5f8
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70541fe2-f9bf-44e9-ac3b-08da638e8278
x-ms-traffictypediagnostic: BN9PR12MB5209:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HMmjAVTGVvXuJviqe0bzYQvwG9wg5hcKNnVYVDuc3kpXbAOUVHe7fScTeQM2lhUeCUe/jVnjJIIw+ghVONuR/cv0pRfbqxtQR/6/jfpIsFKhIf4B4+yjgbbts/zI5EkAZVrVybsoFlc+hewuSZmvo7pwyvZDNfTqbEtLh6ulMq/UlOqbid2Lf1G1ga40n2iyYmnG5bQnHdpa8TXAsvUahvCSzvbOiGjcT1wbpsbSb2sg/93WKGqyoLVprm0E9yvTGtACxANaKdpJukL6OqVfLeVGMhiLLDduu+7v3F/xSdt4IJR0vyCHs4e2IaYWGWGHxYBMTQg23tLUkEJJz4AZWYF4oV29HSrnfPzLf29gXFEP17kato+JTmUbuZwiXPiotQhf4n7YU9n24hQxs4WSUyT+RUN8wvEzNQ+pmcbozKKS4zgoEKKdI1Ovr56ah2Xw6dmaxH8Sz/G3haD0sCwaKZU3xIvTnU8alTqGnKeI+LWz+RpCplm/+Q3A6DPiwcPBwqqQJSMrgRLte0xE7FkKR0ZGnAJUYIf37kwOT/B59sIDSHkVnhOERGmMOXeH1omqCX0Kf84196by74kG5iYm+OFz4CEhIeXUZIdqv0NDibczzO51y7BfKM1lKo/jJ9Top1pThXYM7wTNzUT7C7lMLMptbnsIWYOjhIo9AA+11FWRnNfUHRrViNl5qhxb+LDDYpb4BMDwphaOGESoJryf+D2jBCnfpXhgKZjHLxgUqOasYkY33MUxfbCd2LN6x6qNa8BcQiECUJTIRUXNXv2Ui8u68EW35Ye0u4OaCQjWz94wchqsdYVAvgxlGmMaYz4q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(6506007)(7696005)(54906003)(9686003)(8936002)(26005)(41300700001)(76116006)(83380400001)(5660300002)(71200400001)(7416002)(64756008)(66476007)(316002)(66946007)(66556008)(186003)(2906002)(52536014)(7406005)(6916009)(4326008)(38070700005)(55016003)(8676002)(66446008)(86362001)(38100700002)(478600001)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXJOYkltbUhUUmprMXBvbnJZaWRnOHJ5S21RSXltRnVDdkN2TFNVSDlwL01O?=
 =?utf-8?B?cWZxMVgvV0N5Nk1BUEY3OEtoakxXU0ltVmRGQkcrd1BRVjc5cE9kbUNOdjJZ?=
 =?utf-8?B?N0hDc3R5SXRvUlhoTmhDbXM0N09ETEpZWGExeTVIOFExQnFuNHdTL3VuWCtU?=
 =?utf-8?B?aUdyemk2QTFKZENjcHZtUVhnL2dxS01NYWFQcms5S1pRYUIvUUpQakZ5d3dQ?=
 =?utf-8?B?TmVKeU1EUjhocko0TU15YkFDSll0OHFyU2dsU0d5cTBodXFwdi9JL1AwMnZ6?=
 =?utf-8?B?aEcyUEV2cU82cDRFd3B1TUVEZi95S2FCdW9rN0s2eVpFUTU2RVYxNFNjRFlZ?=
 =?utf-8?B?UGp0aEhKRWNPRjlOSkREcVJLZ043MDJ2TTN2VkM3azBRZ0g2emMrMUR5UWFM?=
 =?utf-8?B?TTZlL3pmbDg5ZTdvcENZY1pVVEtlZUt1dFNGSVRpVjBDWVZLYnNxNUU3ejF2?=
 =?utf-8?B?MWlvNzVrc3lRbzhwdEhrYlNZaldsYnZsandpUVhPaUwvOW8wK2xmWDZaOHFy?=
 =?utf-8?B?aGZuNFJlOGFCeWQwbDIrMXNZOVoweEdkellsV2d5aTN5MlJqb0VGR3BVU2hN?=
 =?utf-8?B?V1RWcVVwSDJnVG9WSDJjTzNVVFRxZGhhdDVuVUF5eWVqRHhmanNqblBobG1m?=
 =?utf-8?B?S2JyS3E3YlE0L3FnRlp1S0NYVFd3MjlCWXliNWxpandnUzhyeXgzRS8vR1lu?=
 =?utf-8?B?RW5CS25pVzlZNWEvS0hEcWZscmdHQndzTytDbURHdTh0TVRDcG03Umg4NWFk?=
 =?utf-8?B?bUNJajljb21ub2hFYm1IUFdqZytZVlYwZ0RhYUFrOVRRS0dOUHdkdWxaOGdp?=
 =?utf-8?B?b1dlZndUN2Nhd0xiMWF6T3YvWmUvd3hKY2x6eFBPU3NYWGVuRkk1ZHRvQy9h?=
 =?utf-8?B?ZG9JTkJWRitmYVBKTEdwMENsNXZ1aGVaMWxiZVEyVFpzRWVpeHR2Q1lGTEwr?=
 =?utf-8?B?ZldQZlM0eTZFYnExbXhmWkJFREFQN3NKV3VZc2hFelVIU0FLbDRNV2tvek9a?=
 =?utf-8?B?N2FLNG9XQWNJR1ZyMXNpNXQ4VTZCVHNDSWE5eVRoU0VuTnF6M2hFZnJtRVIv?=
 =?utf-8?B?eWZhYXNNR1kvRkdmb28vWWRiRlh0U1B0Q0FYNEJPOEVNTTNsWDgycVRWWC9S?=
 =?utf-8?B?Zm45Vk1KcmZrZ3BsV3RhR3dMUy8veVZlc0hEMFBRSDg2ajVFdU1DYjhDQTVW?=
 =?utf-8?B?UU5Zb0VUQmJ1ZjlodjhQN0FjMkhlQXVpWDlTRE5CaU9VMnQzUVMxQnU5Y3NQ?=
 =?utf-8?B?L3UvM09zVkFTVnNTYzlBZ20rVlEzOW9wWjl4UWR5RzJRUXlPN3ZneDlKM0h4?=
 =?utf-8?B?L3FCU1hkT0ZqbDVjNk1DT2Q4dWNrNGhaSEt0Zm1UYUxnT0dHYnVBVGtKY2tF?=
 =?utf-8?B?MW13UFRvdHBaREhLdFhBNkJvUmtZZWZyNmFvRWR1R3VUanM0RGU3dmpsdzFy?=
 =?utf-8?B?d3dZV2JuYzJ3dmZyTUwxNmtpd0hJM0NDZ2lFWFdPb1BIVlF5QWtOSHhHcWI5?=
 =?utf-8?B?TWQ2czNSQjdXd0xHNnhEYUQ0UTBsWW54a2FLMXkxS3gzcHlySDlwNTRGNGwy?=
 =?utf-8?B?TDZaa0laUFJkSmxPSFF3U3cvRFF0aWJQamZBemxpenlTVmtTVUtDbFh3WWdS?=
 =?utf-8?B?dGNWTGsyaUZkSFBFZStHTVFyOW45VE5JNXdjRUVvajhKOSs1TDVjL1ZCdzBk?=
 =?utf-8?B?dGoyWVMyYW9PZGJDQlNaWkRDdEtiMmFlQjN4Q01kVmtFS1l6dGZsNzlld2RS?=
 =?utf-8?B?QjdVSnQ5aXBoTFNWOWR5S0NIOWY1dnFZbTUvYVVQU3pac0Ruc0RSRTlFaTF1?=
 =?utf-8?B?bDhjTlhMcnVsRjZrTVVaSnl3eEVSK0lGVTBtd05hczlkOGt3UUlaZjk5Sk5T?=
 =?utf-8?B?bWEzOWh2NjUyd2FzelpLQXJuUmtaSk1iMVVVakl2c242a05JTldhOHJrZW9p?=
 =?utf-8?B?Nnk3eldoWlZEMlBmVlg0eWJTTmgzdit5d0R1RXVmVndxQmZqc3dHOWhEdEo3?=
 =?utf-8?B?K3IyTVhWRlJ1M2FvUGdTMThTajAwVVRiMGhjOXRoa0ViS3EvWTE0NWlncWhj?=
 =?utf-8?B?d1MwSWNWWnIvY3lRZitlMk0xR1B1WUFNOVpnT2ZIcytVVWVGRlRoTmluRHhK?=
 =?utf-8?Q?fSLw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70541fe2-f9bf-44e9-ac3b-08da638e8278
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 22:41:35.1330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2B8AAgnkaNV2w+5Hjzqmz8SpRBcfrGQtGs+ixnl8KaHG7zN22P5ak2v47WrIK6oi49C88dYMMpWGb3hzZKqtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5209
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQo+PiBU
aGUgS1ZNX1NFVl9TTlBfTEFVTkNIX0ZJTklTSCBmaW5hbGl6ZSB0aGUgY3J5cHRvZ3JhcGhpYyBk
aWdlc3QgYW5kIA0KPj4gc3RvcmVzIGl0IGFzIHRoZSBtZWFzdXJlbWVudCBvZiB0aGUgZ3Vlc3Qg
YXQgbGF1bmNoLg0KPj4NCj4+IFdoaWxlIGZpbmFsaXppbmcgdGhlIGxhdW5jaCBmbG93LCBpdCBh
bHNvIGlzc3VlcyB0aGUgTEFVTkNIX1VQREFURSANCj4+IGNvbW1hbmQgdG8gZW5jcnlwdCB0aGUg
Vk1TQSBwYWdlcy4NCg0KPkdpdmVuIHRoZSBndWVzdCB1c2VzIHRoZSBTTlAgTkFFIEFQIGJvb3Qg
cHJvdG9jb2wgd2Ugd2VyZSBleHBlY3RpbmcgdGhhdCB0aGVyZSB3b3VsZCBiZSBzb21lIG9wdGlv
biB0byBhZGQgdkNQVXMgdG8gdGhlIFZNIGJ1dCBtYXJrIHRoZW0gYXMgInBlbmRpbmcgQVAgYm9v
dCBjcmVhdGlvbiBwcm90b2NvbCIgc3RhdGUuIFRoaXMgd291bGQgYWxsb3cgdGhlIExhdW5jaERp
Z2VzdCBvZiBhIFZNIGRvZXNuJ3QgY2hhbmdlID5qdXN0IGJlY2F1c2UgaXRzIHZDUFUgY291bnQg
Y2hhbmdlcy4gV291bGQgaXQgYmUgcG9zc2libGUgdG8gYWRkIGEgbmV3IGFkZCBhbiBhcmd1bWVu
dCB0byBLVk1fU05QX0xBVU5DSF9GSU5JU0ggdG8gdGVsbCBpdCB3aGljaCB2Q1BVcyB0byBMQVVO
Q0hfVVBEQVRFIFZNU0EgcGFnZXMgZm9yIG9yIHNpbWlsYXJseSBhIG5ldyBhcmd1bWVudCBmb3Ig
S1ZNX0NSRUFURV9WQ1BVPw0KDQpCdXQgZG9uJ3Qgd2Ugd2FudC9uZWVkIHRvIG1lYXN1cmUgYWxs
IHZDUFVzIHVzaW5nIExBVU5DSF9VUERBVEVfVk1TQSBiZWZvcmUgd2UgaXNzdWUgU05QX0xBVU5D
SF9GSU5JU0ggY29tbWFuZCA/DQoNCklmIHdlIGFyZSBnb2luZyB0byBhZGQgdkNQVXMgYW5kIG1h
cmsgdGhlbSBhcyAicGVuZGluZyBBUCBib290IGNyZWF0aW9uIiBzdGF0ZSB0aGVuIGhvdyBhcmUg
d2UgZ29pbmcgdG8gZG8gTEFVTkNIX1VQREFURV9WTVNBcyBmb3IgdGhlbSBhZnRlciBTTlBfTEFV
TkNIX0ZJTklTSCA/DQoNCmludCBzbnBfbGF1bmNoX3VwZGF0ZV92bXNhKHN0cnVjdCBrdm0gKmt2
bSwgc3RydWN0IGt2bV9zZXZfY21kIA0KPj4gKyphcmdwKSB7DQo+PiArICAgICAgIHN0cnVjdCBr
dm1fc2V2X2luZm8gKnNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOw0KPj4gKyAgICAg
ICBzdHJ1Y3Qgc2V2X2RhdGFfc25wX2xhdW5jaF91cGRhdGUgZGF0YSA9IHt9Ow0KPj4gKyAgICAg
ICBpbnQgaSwgcmV0Ow0KPj4gKw0KPj4gKyAgICAgICBkYXRhLmdjdHhfcGFkZHIgPSBfX3BzcF9w
YShzZXYtPnNucF9jb250ZXh0KTsNCj4+ICsgICAgICAgZGF0YS5wYWdlX3R5cGUgPSBTTlBfUEFH
RV9UWVBFX1ZNU0E7DQo+PiArDQo+PiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBrdm0tPmNyZWF0
ZWRfdmNwdXM7IGkrKykgew0KPj4gKyAgICAgICAgICAgICAgIHN0cnVjdCB2Y3B1X3N2bSAqc3Zt
ID0gDQo+PiArIHRvX3N2bSh4YV9sb2FkKCZrdm0tPnZjcHVfYXJyYXksIGkpKTsNCg0KPiBXaHkg
YXJlIHdlIGl0ZXJhdGluZyBvdmVyIHxjcmVhdGVkX3ZjcHVzfCByYXRoZXIgdGhhbiB1c2luZyBr
dm1fZm9yX2VhY2hfdmNwdT8NCg0KWWVzIHdlIHNob3VsZCBiZSB1c2luZyBrdm1fZm9yX2VhY2hf
dmNwdSgpLCB0aGF0IHdpbGwgYWxzbyBoZWxwIGF2b2lkIHRvdWNoaW5nIGltcGxlbWVudGF0aW9u
DQpzcGVjaWZpYyBkZXRhaWxzIGFuZCBoaWRlIGNvbXBsZXhpdGllcyBzdWNoIGFzIHhhX2xvYWQo
KSwgbG9ja2luZyByZXF1aXJlbWVudHMsIGV0Yy4NCg0KQWRkaXRpb25hbGx5LCBrdm1fZm9yX2Vh
Y2hfdmNwdSgpIHdvcmtzIG9uIG9ubGluZV9jcHVzLCBidXQgSSB0aGluayB0aGF0IGlzIHdoYXQg
d2Ugc2hvdWxkDQpiZSBjb25zaWRlcmluZyBhdCBMQVVOQ0hfVVBEQVRFX1ZNU0EgdGltZSwgdmlh
LWEtdmlzIGNyZWF0ZWRfdmNwdXMuDQoNCj4+ICsgICAgICAgICAgICAgICB1NjQgcGZuID0gX19w
YShzdm0tPnNldl9lcy52bXNhKSA+PiBQQUdFX1NISUZUOw0KPj4gKw0KPj4gKyAgICAgICAgICAg
ICAgIC8qIFBlcmZvcm0gc29tZSBwcmUtZW5jcnlwdGlvbiBjaGVja3MgYWdhaW5zdCB0aGUgVk1T
QSAqLw0KPj4gKyAgICAgICAgICAgICAgIHJldCA9IHNldl9lc19zeW5jX3Ztc2Eoc3ZtKTsNCj4+
ICsgICAgICAgICAgICAgICBpZiAocmV0KQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0
dXJuIHJldDsNCg0KPkRvIHdlIG5lZWQgdG8gdGFrZSB0aGUgJ3ZjcHUtPm11dGV4JyBsb2NrIGJl
Zm9yZSBtb2RpZnlpbmcgdGhlIHZjcHUsbGlrZSB3ZSBkbyBmb3IgU0VWLUVTIGluIHNldl9sYXVu
Y2hfdXBkYXRlX3Ztc2EoKT8NCg0KVGhpcyBpcyB1c2luZyB0aGUgcGVyLWNwdSB2Y3B1X3N2bSBz
dHJ1Y3R1cmUsICBidXQgd2UgbWF5IG5lZWQgdG8gZ3VhcmQgYWdhaW5zdCB0aGUgS1ZNIHZDUFUg
aW9jdGwgcmVxdWVzdHMsIHNvIHllcyBpdCBpcw0Kc2FmZXIgdG8gdGFrZSB0aGUgJ3ZjcHUtPm11
dGV4JyBsb2NrIGhlcmUuIA0KDQo+PiArICAgICAgIC8qDQo+PiArICAgICAgICAqIElmIGl0cyBh
biBTTlAgZ3Vlc3QsIHRoZW4gVk1TQSB3YXMgYWRkZWQgaW4gdGhlIFJNUCBlbnRyeSBhcw0KPj4g
KyAgICAgICAgKiBhIGd1ZXN0IG93bmVkIHBhZ2UuIFRyYW5zaXRpb24gdGhlIHBhZ2UgdG8gaHlw
ZXJ2aXNvciBzdGF0ZQ0KPj4gKyAgICAgICAgKiBiZWZvcmUgcmVsZWFzaW5nIGl0IGJhY2sgdG8g
dGhlIHN5c3RlbS4NCj4+ICsgICAgICAgICogQWxzbyB0aGUgcGFnZSBpcyByZW1vdmVkIGZyb20g
dGhlIGtlcm5lbCBkaXJlY3QgbWFwLCBzbyBmbHVzaCBpdA0KPj4gKyAgICAgICAgKiBsYXRlciBh
ZnRlciBpdCBpcyB0cmFuc2l0aW9uZWQgYmFjayB0byBoeXBlcnZpc29yIHN0YXRlIGFuZA0KPj4g
KyAgICAgICAgKiByZXN0b3JlZCBpbiB0aGUgZGlyZWN0IG1hcC4NCj4+ICsgICAgICAgICovDQo+
PiArICAgICAgIGlmIChzZXZfc25wX2d1ZXN0KHZjcHUtPmt2bSkpIHsNCj4+ICsgICAgICAgICAg
ICAgICB1NjQgcGZuID0gX19wYShzdm0tPnNldl9lcy52bXNhKSA+PiBQQUdFX1NISUZUOw0KPj4g
Kw0KPj4gKyAgICAgICAgICAgICAgIGlmIChob3N0X3JtcF9tYWtlX3NoYXJlZChwZm4sIFBHX0xF
VkVMXzRLLCBmYWxzZSkpDQo+PiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIHNraXBfdm1z
YV9mcmVlOw0KDQo+V2h5IG5vdCBjYWxsIGhvc3Rfcm1wX21ha2Vfc2hhcmVkIHdpdGggbGVhaz09
dHJ1ZT8gVGhpcyBvbGQgVk1TQSBwYWdlIGlzIG5vdyB1bnVzYWJsZSBJSVVDLg0KDQpZZXMgdGhl
IG9sZCBWTVNBIHBhZ2UgaXMgbm93IHVuYXZhaWxhYmxlIGFuZCBsb3N0LCBzbyBtYWtlcyBzZW5z
ZSB0byBjYWxsIGhvc3Rfcm1wX21ha2Vfc2hhcmVkKCkgd2l0aCBsZWFrPT10cnVlLg0KDQpUaGFu
a3MsDQpBc2hpc2gNCg==
