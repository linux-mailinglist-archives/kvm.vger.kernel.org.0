Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD4F555317
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377507AbiFVSPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377497AbiFVSP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:15:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B8D3DA55;
        Wed, 22 Jun 2022 11:15:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQweJpeTkM7H2YrR3tnGVgaoiqGwzXFJ3ei4lSAMxTzVj5hAW4cTKpx0DhYWAuzmoyVxLsiDDTbGIqAijO0fJwO1c6ZAC32vMJsWXI5hbdOA40C4TZdRotgwhzVrWarjKKqXvIq+FrZQT4tAAdv5IVY7fyHLkj4smYieRuBiu05ZSfchZS3OHHzLG0SskXUn5cMLkOwfY2yB0xtLKL8FVnWdfZGABXkW/2NsrJSLxbQy/Li4MZx+igyXrnZcwS7+pfl66rGtS+AHrJTbINs4r+plrPdZAx6SDdrJMKqSptMuJ4fHXYhVNt1nkuRTAqd8GqGvdIzUEpEurTXv+nfPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6m3sepo/KDyWs5I/vhQl4zx4vEVEa455fLgYva4olMo=;
 b=ZaP05VPNhc0EAzEm9Rs+4CBj45CUTudC7aI1iL7IVKHW0no5UGbxqUOCQdvmivyYjE7mL+WlKkW+5Q34CSUokjf5iS0BIAkJUt2ZfuUCC2q2ksy9oK7Qehzpnz2idclTFT3AOeQHNgCVa2aqIZA9zXYK8EGZCgV2H5YEVUri1XaDyXnfLmMkvwmT4odUKsJ9u8Qu5KNS/f8+fc2wSJ1xYDoXpp0LIqx08s77AVtExM70e26pWCWGaz2levxzCEpNdo/fYjGCYwcB/iYVrat5bvwvhTbLeZXH+9QgZ6/eQ2Q5+u3RtBLDpiROm7/0eRR/okZ3ADLBWjvtqpwcPlBRug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m3sepo/KDyWs5I/vhQl4zx4vEVEa455fLgYva4olMo=;
 b=Q47w7FwBFBUqptrhCyYz7RhsbV02frpZKIRLEuPVenHKE4pLsDWiq9H20mmT1uO4WDFXvRhjqZXUC2cuiR1TcYEOjGwGAi2kn8eCy+X/jirx7NXAX43/CdeMLVboqXjhiQU4OoUD8AH1U4NW4b2rJP955H8TMEzfiIoLwZQYtOQ=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by MN2PR12MB3184.namprd12.prod.outlook.com (2603:10b6:208:100::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Wed, 22 Jun
 2022 18:15:19 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 18:15:19 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
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
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Topic: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8A==
Date:   Wed, 22 Jun 2022 18:15:19 +0000
Message-ID: <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
In-Reply-To: <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-22T18:15:10Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=ed25ecde-e948-40c6-aa70-36ba88dd1700;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-22T18:15:17Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 35dd1998-8df9-4fdb-8ceb-b8aca11025d1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f245af2d-7772-437b-1827-08da547b2a5b
x-ms-traffictypediagnostic: MN2PR12MB3184:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3184CDFB2DA4284985FD6D5D8EB29@MN2PR12MB3184.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVFdEGcyi/2wBaQs8Gz15HAVLF3KcZZ2foe8ouhz09xPfyfmvI/lu+MMeF2BAR98cI8ENbOw0TeqRLlcbbwZsQMxYFkaSncYRK8f6EHOsvj1NS9y+E+VUmgMtcFm0+bU0ya25588Gdco2gbmd9U8zUoBossgg1Qgf6lepMQIJQwpDjuHNn8ukNXGXdp9acTOOnGIE/tL45b6UO+fLgvHlzEXYjgMlW6LiRjZA7mAX1ib5HIXL7mNvE9syFHkwPyB5gmcjFaxDeZ2JCKwUycyc3vaAwUO3O3ABm9bTBZ1Jf0WQIA7aieFgoB0BcVf/IvMRo5oFU7pyH15QUqgvtxrgWIByW1KwT9O+YRSNcDo/8XbCADhHqm0gMxSoLfnuRXbofNjj8P+wAYWfgt+2Qq+IOjY4URwfCxUSga9SzrD+lUItC0PEGHR6NCFF8brOv08CJz9L3ZaBjFtDUOpX1gUzZW5oPFR1izUh3MGH8TP6axIa3f5/Ubgdk845PljiY9iKoFF/M23MbyWZl/gj+4X5P5muGpMfly55L7Pw/XPpvFf9TgjzHYWFucR+mmqpz7MxEfVGPHl58frNTgBZyQJOeMTod4X4DSsEcSgMMkuohPhHZgRXOW4k6wXq27WBlgIRuAcdBrbu8huAzPZEmGQL6EowkC4xTW3m1m9uSJ3IBDw0jXKYq6RXjlDCNjL8cirvsOf/uaSOzulJyxS/ATTPZmTymzulVkDvO3Hv5WupUqOOqUNLgFg17A6Lt6T6BnROACFupx+KR9d5BrTXicqvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(26005)(316002)(8936002)(54906003)(2906002)(38070700005)(52536014)(38100700002)(55016003)(86362001)(110136005)(9686003)(66446008)(66556008)(8676002)(122000001)(71200400001)(4326008)(64756008)(76116006)(53546011)(83380400001)(41300700001)(66476007)(478600001)(33656002)(186003)(7416002)(7406005)(7696005)(6506007)(66946007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmViZEJkdFczakNERVkyaUkrcm1kZXp6NHIycyttdHhmTkJ4a085MGhVY0Va?=
 =?utf-8?B?UG9DS2dESDJXMFVwWXFzTlViemdzQkRGQlY2ZkNPdTJMVGVBWFJmelFlODFF?=
 =?utf-8?B?aXVrRmNvOHVVOFVQVSt5a29FUXBsTDNteG9WalM1ZFlkMDRNZHVhcVpjeEZW?=
 =?utf-8?B?WjVEVXgvRlZxbUN0Ulp3Q3VyRnZTRVd0OWExUU4zWmpEUGJtNWIzSml6RGgx?=
 =?utf-8?B?VkZsK2M1Y28yajN3elNZQno2UzJJL3haMEJXQkJxUGRWRXExQ3VLUUNnbGtk?=
 =?utf-8?B?UmJkMGxETnBDVTBVRVkwa25ReTdlaWNiRWdYWnUvdW8rVXB3RHVBZlBXZHRY?=
 =?utf-8?B?bU80MTA2WWVGKzRjbk1QazV1RjF1MEVDN1FMbzgyU1FNb1Z1N0xITXJPU0Vv?=
 =?utf-8?B?OUdLR2JOT05JQUNSbnRWOEVDeW94TTloWTB4bHNwSG5SZXRhVlZnMzArR0or?=
 =?utf-8?B?a2s3UlZVYkF4aVVDbkthN29PSy9FY3kzUTFEdzdBd0RpN3NqTXp4OHdrMTBv?=
 =?utf-8?B?aUtSZG1kdkpOcFcvMGk3V2FONGdRdHIyRXZjWEJCeEZWeTdmSHhQVWwwa1Bl?=
 =?utf-8?B?WXl5SGNvM2tkWm4xV0ZBaE0zVE1ZS3lNTGpHR3dPKzlTZHp3UHNrQzlkOVpX?=
 =?utf-8?B?bXFoei9OTXVoTEkzbFlhaXlib3hrelNtdytESUZ4NlBVMlZ1emxaK0hNSU0z?=
 =?utf-8?B?MUFCZmJXLzdUR2VtODJUeWUrako5dysxKzQ3S0ZxZStleWlCa0J6WUQ1K0l1?=
 =?utf-8?B?WkxGNmF5UVdSejBoVXBZWVF0REVDb2Ryb1EyWHhZN0ZaY0t2OEtKU2FXL3Er?=
 =?utf-8?B?NTc2ME93RCtRcUVDd0t6cEtKOWpDbTBhY2J6K20wSlRvVTRUY1FUWGNRSTBO?=
 =?utf-8?B?cEhjeFdVZ1Nvb3UzWHBmMWdwTFVTZGRtOTZhUndYUExWaHVsMUJaS0U4dE84?=
 =?utf-8?B?NVRSQSs5ZGNUN1gxRWNzdUZQc0k4Nm9BL0NkWThlWDlqWmF1MmxlWnc0K1dS?=
 =?utf-8?B?NmplN29RWXdIZlV5SFlhNDdBK0NLRnFOS0NvR3hDdWxFdFlmSUthTVpRcXla?=
 =?utf-8?B?SHgxL1lPOFdmYzVsazk4NzlDWk1JU2toeGpUT0R5MTM0VlZEeGh1ZDJBQXNM?=
 =?utf-8?B?M21qbHRqby9zUnVOZTBRcmQwY2ZJbFVVdDFiY3Q1aHZOSmxXL25NNC9BZWxP?=
 =?utf-8?B?c0hyYXhvK2hzTzI4KzJ2bGZNNmpNbExxL1RUOG1SajFrZXR5NksrQXU0SzRV?=
 =?utf-8?B?WC90NVkrcHRxVUdHdzF0cTRybDFDZWxveFFWeGJlRjZ2Y014RlRQb0tJdTUw?=
 =?utf-8?B?OXNjODU0K1Vvc0NSYUhMQ2tnanF1cDBSaWZTWFlzRnhmNlNMR3dhMWY5TFN6?=
 =?utf-8?B?MTU3ZmJLeGJHVWZaam1makcxdFc2b1ZZZlVobUEycHgvTllwZm5ybDFMSlFF?=
 =?utf-8?B?MDA5SE5ZVHQzdS9Qb1VlYUpUSGs2eEh4VFFpaEJWNm93U1hsQ2JQZmlRSHhi?=
 =?utf-8?B?Z0czaWZwME1sRXVGTFdZS0NQUnF4NXJFK1NtV0J0dHZwMm1vM1Znc0Z5OHJp?=
 =?utf-8?B?TkpOdmNtUW4xai8yM0t4RTRZS1kxejNDemJkaERWQzZXcnhhMTRZKzhzay9k?=
 =?utf-8?B?MVExQ2NBWnNGVDhuODBnb2hlMGZaWi84alAxQUlDYUtZSlVvd0pWV0FEdyt6?=
 =?utf-8?B?V2VJRnhqWW9qd0JMYlBPcUMyMzkvL3gwZnNwMXcxcXdpSVhJN1hpenVWODJJ?=
 =?utf-8?B?QUlSb2RCQ3Zaa0dSb1lCTG84eVlMbnNVL21OMTlIWlVxeUR0K0tIN3g3aDc5?=
 =?utf-8?B?NE1CR0ZUU0tDdHo3SlhBdGJHRGsxWkJMWE12VDR5VTlZZGNvWlVjY2FEVlda?=
 =?utf-8?B?WWo0SHNzMHZQaUZXWU95REZCUG44R0taWTdHVTdnUVNDZGRtUHBObDlORHFy?=
 =?utf-8?B?YkluNWRMQ1N2ckN2UW8rayt0bzlIV1VDRFliWmw4c3JtV1c3VTUrd3h0Qjha?=
 =?utf-8?B?YWViRTZsbXFtRmNEbDhSbGN5UGx5V1A5dTNDeGdwRUNwVnlTQURnbk9FSEZY?=
 =?utf-8?B?YzFLbDhmYUV2a3pjNzRRbm41aXg1bmVYaTh0THhSekhrTjdZeHJBOFk2Y2JS?=
 =?utf-8?B?SzZ3VUVzWDFhUmEyWVZYT2tyVVVXQmIvRGdQb1VVODEzUFRQeURESko2VkRp?=
 =?utf-8?B?SHJML2JFSTdUdHQ1TjBKZUFQSVlPZDRGTkRrS3JYUG01Z081RlNkSXFzUDk2?=
 =?utf-8?B?ZXB0ajJIOFJQQzdoU1ZReWc5RXNBQ2cxaHV6aHFFME1ZTjdiTERpaXFEUlU1?=
 =?utf-8?Q?Kma1Ar/OH3H5f9BLYm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f245af2d-7772-437b-1827-08da547b2a5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 18:15:19.4357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fc2IapkUKK13dh78uBloy+EJzmV7IxRM6MASFfAY1DQtzV3BFVp6FqNTMDZEft+rLaPMRnfU1Lvk+PkmTkHi8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3184
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KT24gNi8yMi8yMiAwNzoyMiwgS2FscmEsIEFzaGlzaCB3cm90ZToNCj4+IEFz
IEkgcmVwbGllZCBwcmV2aW91c2x5IG9uIHRoZSBzYW1lIHN1YmplY3Q6IEFyY2hpdGVjdHVyYWwg
aW1wbGllcyANCj4+IHRoYXQgaXQgaXMgZGVmaW5lZCBpbiB0aGUgQVBNIGFuZCBzaG91bGRuJ3Qg
Y2hhbmdlIGluIHN1Y2ggYSB3YXkgYXMgdG8gDQo+PiBub3QgYmUgYmFja3dhcmQgY29tcGF0aWJs
ZS4gSSBwcm9iYWJseSB0aGluayB0aGUgd29yZGluZyBoZXJlIHNob3VsZCANCj4+IGJlIGFyY2hp
dGVjdHVyZSBpbmRlcGVuZGVudCBvciBtb3JlIHByZWNpc2VseSBwbGF0Zm9ybSBpbmRlcGVuZGVu
dC4NCj5ZZWFoLCBhcmNoLWluZGVwZW5kZW50IGFuZCBub24tYXJjaGl0ZWN0dXJhbCBhcmUgcXVp
dGUgZGlmZmVyZW50IGNvbmNlcHRzLg0KDQo+QXQgSW50ZWwsIGF0IGxlYXN0LCB3aGVuIHNvbWVv
bmUgc2F5cyAibm90IGFyY2hpdGVjdHVyYWwiIG1lYW4gdGhhdCB0aGUgYmVoYXZpb3IgaXMgaW1w
bGVtZW50YXRpb24tc3BlY2lmaWMuICBUaGF0LCBjb21iaW5lZCB3aXRoIHRoZSBtb2RlbC9mYW1p
bHkvc3RlcHBpbmcgZ2F2ZSBtZSB0aGUgd3JvbmcgaW1wcmVzc2lvbiBhYm91dCB3aGF0IHdhcyBn
b2luZyBvbi4NCg0KPlNvbWUgbW9yZSBjbGFyaXR5IHdvdWxkIGJlIGdyZWF0bHkgYXBwcmVjaWF0
ZWQuDQoNCkFjdHVhbGx5LCB0aGUgUFBSIGZvciBmYW1pbHkgMTloIE1vZGVsIDAxaCwgUmV2IEIx
IGRlZmluZXMgdGhlIFJNUCBlbnRyeSBmb3JtYXQgYXMgYmVsb3c6DQoNCjIuMS40LjIgUk1QIEVu
dHJ5IEZvcm1hdCANCkFyY2hpdGVjdHVyYWxseSB0aGUgZm9ybWF0IG9mIFJNUCBlbnRyaWVzIGFy
ZSBub3Qgc3BlY2lmaWVkIGluIEFQTS4gSW4gb3JkZXIgdG8gYXNzaXN0IHNvZnR3YXJlLCB0aGUg
Zm9sbG93aW5nIHRhYmxlIHNwZWNpZmllcyBzZWxlY3QgcG9ydGlvbnMgb2YgdGhlIFJNUCBlbnRy
eSBmb3JtYXQgZm9yIHRoaXMgc3BlY2lmaWMgcHJvZHVjdC4gRWFjaCBSTVAgZW50cnkgaXMgMTZC
IGluIHNpemUgYW5kIGlzIGZvcm1hdHRlZCBhcyBmb2xsb3dzLiBTb2Z0d2FyZSBzaG91bGQgbm90
IHJlbHkgb24gYW55IGZpZWxkIGRlZmluaXRpb25zIG5vdCBzcGVjaWZpZWQgaW4gdGhpcyB0YWJs
ZSBhbmQgdGhlIGZvcm1hdCBvZiBhbiBSTVAgZW50cnkgbWF5IGNoYW5nZSBpbiBmdXR1cmUgcHJv
Y2Vzc29ycy4gDQoNCkFyY2hpdGVjdHVyYWwgaW1wbGllcyB0aGF0IGl0IGlzIGRlZmluZWQgaW4g
dGhlIEFQTSBhbmQgc2hvdWxkbid0IGNoYW5nZSBpbiBzdWNoIGEgd2F5IGFzIHRvIG5vdCBiZSBi
YWNrd2FyZCBjb21wYXRpYmxlLiBTbyBub24tYXJjaGl0ZWN0dXJhbCBpbiB0aGlzIGNvbnRleHQg
bWVhbnMgdGhhdCBpdCBpcyBvbmx5IGRlZmluZWQgaW4gb3VyIFBQUi4NCg0KU28gYWN0dWFsbHkg
dGhpcyBSUE0gZW50cnkgZGVmaW5pdGlvbiBpcyBwbGF0Zm9ybSBkZXBlbmRlbnQgYW5kIHdpbGwg
bmVlZCB0byBiZSBjaGFuZ2VkIGZvciBkaWZmZXJlbnQgQU1EIHByb2Nlc3NvcnMgYW5kIHRoYXQg
Y2hhbmdlIGhhcyB0byBiZSBoYW5kbGVkIGNvcnJlc3BvbmRpbmdseSBpbiB0aGUgZHVtcF9ybXBl
bnRyeSgpIGNvZGUuIA0KDQpUaGFua3MsDQpBc2hpc2gNCg==
