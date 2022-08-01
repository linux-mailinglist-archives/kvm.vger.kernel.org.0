Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE725873B6
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 00:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiHAWEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 18:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiHAWEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 18:04:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25173DBEF;
        Mon,  1 Aug 2022 15:04:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTpOxIYfTm2b7lo6T4BwvhSBaNW+7i+Xn15DbZF1/78mbS+zLB9j/302yGR0FWTq2bN37Bft7+9XAinnyhMYoiGnPCWNoLnqR6kydGSy+Im2mf6dwfYfB7BTKrOS+DClos4mPiM4PxoQd0GgPTSchUdUpy8Hj336k2WHRkLzRyhZH2Md8JqYMjYM0PUWy9IznBm/xyZBHG3h96kmuQU5InqIO+lVxKer1G0yceVqV6VntBNNakEGPhfbYxbh1DaqG8TQF6nLuBrDiDuA7fNYIdyHvb+uafuqUut9bzaD9KxLp6xf68N0+vid67MOC3OQiwUhGKbpym/NHcZVW0vRtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F901Z1GUjCtkHJCwcg1giQzGL7Y1nTcYeUOeDfuYTDg=;
 b=ROnWZfVpXyDu1dFViAbKBoGLfnQVSPU9Apb2NqK2E07H9WRW4xoCjSYbgv+7OAL98zhE71V1xbfxIf1aIzd33l3scRFYmRpFmERpaYd2/3BQlBj8vfXkDnXNa2QNOUvoa+ow5Bqx0ofN/YZw1bAlj6Dh9n11sgQsRpliHFS6BR3DFxZwvUwmamrgbmyO/8Pl9j0m6Kd2jOfV4VpGk2dQIM9zhPAfg5F19kpCijbbarazhrChDrDXngyVyU5lmvWriMZItnmDSSkASf4ljmj4J77dB0l0Adv/Ij3ORGCsMUUHZJm3Lns9nt9iBaIMszzBCqAH0k535mAAvFr0XZM+AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F901Z1GUjCtkHJCwcg1giQzGL7Y1nTcYeUOeDfuYTDg=;
 b=aoG3a/fdhiguPGc0KQG6YUoAPSD4sokltfW2A+qCWkOmFo61WgOX2qaJ9Wo7QCUU5dg+n7j5vZsGXfup/OjRVyxo0QjV2UWjfVEdLhwg6YiWocjaSYBW+eO3GwTCKYO+QeShas7m6LpWh01Q7Tvsi+vF4gzgiWuFnQBOAlouozM=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN6PR1201MB2513.namprd12.prod.outlook.com (2603:10b6:404:ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 22:04:44 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 22:04:44 +0000
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
Subject: RE: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Topic: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Index: AQHYoDNZxoulqFGNPUKcxDbs1JD29a2apLow
Date:   Mon, 1 Aug 2022 22:04:44 +0000
Message-ID: <SN6PR12MB276799EB1B95BD34895CD5608E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
 <Yt6pYu1D28DPatcK@zn.tnic>
In-Reply-To: <Yt6pYu1D28DPatcK@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T22:03:43Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=d4cb74da-d850-4e20-9087-ba32bde07510;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T22:04:43Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 84df3453-76c3-41c3-aa5d-17ba3b6bde9e
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98b2b62e-d858-45dd-3af9-08da7409d7a1
x-ms-traffictypediagnostic: BN6PR1201MB2513:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qq4v1bX+u66H7VqWO4Nz2ULjvm0vOzaTpbU9CMAPqaRtYVigN90SB8fkpPCCMzq8CtWkXt7EP2DrGr5wmYzdNu+0a8voregiegCgdmVSrCYTD8kLZ7OLLh59EJkTEVrgvk/uWtUVUYzDScGwZZcIpUZ3rCpGpXi8eTKYifSnNfhP6opr8/Xvae8XKJQpMR/7H0I4TAgZ9+Qf4g3hq6BjYEzbnVSXaUNh/KdYjZe1p3nRznJGilCYHvBIZa7fmxveLXKJVH8T20DEkwb85Hed3Df+ysp6MukyHHTIHBa+PicuPgirxJLRBn99cMZ530o7t1CEu+mYv0153LxqdWH4TiCTH9pVZCh9LgriiFoQgnza/dnrv/+pbWhCtziAQ25oQq/z0wrYQC4iSUyi2aXkP6ZzHc0Ralx7gE5DYcWpv8Oij9i0B2EUc9apvi0cerUEMMaubRGDSkupNqKLFIH8NNnDNAEOUul9N5aKEoDQ7b3Ju0LiXkiLN+QFK4uie07EkGUjg5f4adCR3AABACop6BLknVCqbD3mCnjX9gkO+dZQReEhZnWD0VyzKYB2B0h8lM+O6Jq3vNta24DCpxHB/iVz9lGL/0//q6kFzM7uOI2F4pD9wNxEJlvw49ZiciM53OjR/9ZZxcgmn1RZA7Rmc6uPREsDLk/HfQ5MTnKzsX3FDxBILT3ez8hsSD1AlkkuZ6S3kKL+7s4tHk8ae+vNs3Acy6VuG9sXH3xjmaKR95EmZ5O03TBqvIwNcdwI+y9las2qQmjg5K+hIjXUQw2JjC1W+f8tizS4QRFvxMwVKq4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(38070700005)(2906002)(52536014)(33656002)(7696005)(38100700002)(478600001)(6506007)(122000001)(7416002)(26005)(5660300002)(64756008)(66946007)(4326008)(55016003)(76116006)(66476007)(66556008)(86362001)(8676002)(9686003)(8936002)(66446008)(4744005)(7406005)(316002)(186003)(54906003)(6916009)(71200400001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JDW0QXv+jPre5Map7Lc5SABVYhhp8afUT57yENPPS5FjMdXf59q9S1hJqj4C?=
 =?us-ascii?Q?VmldOzbsmys2sZWA+lJEXEvCRnS9pGyD1tRThx7K0XW2TRpCFjJILoyJ5qid?=
 =?us-ascii?Q?of/lK8QbnOVXWswq0MOL8KwPJW44Si1c1GR0fXctuD21ysj/PTvJptngtxit?=
 =?us-ascii?Q?1dm5LjcbX0no631rcJvFc6H0T/6TAbz6/oeYQXAPV3piP+pWgSgHvgoXbAvN?=
 =?us-ascii?Q?fsF2VE50TnRInrj4N2nyoFRW7VyXKokj+sW0ydNk1QgE53U3qmgwC91VanV/?=
 =?us-ascii?Q?d3bfCszUxKI+Dw0t3HM969HK4hKqLQgRGJhT1wizotGN1uTMlGMGcs7hNnFS?=
 =?us-ascii?Q?GCjGbNlywIsZALbMq9AEjdcgzdW4AgX1geR8r/duvA31lSuOJQ35ASw+XwZO?=
 =?us-ascii?Q?ornYZifrvD2j24j7xJJ6Rbee/Ukw2IQ525eFoh0DdM3g6GiYDIAmKPS6w7XL?=
 =?us-ascii?Q?de7QecNrdLA30VR66aGNYV+RgjQ+73Icr7mhc2cRMjl0/XnGNL+CfgiGLj+p?=
 =?us-ascii?Q?tCq0x4SH3ZbDSYlQKJaKsnvQvaPe8a/QwXlIyx87nbf+5woJsxdGpMN08seh?=
 =?us-ascii?Q?jtUKwg54kMfdw855y2TXWGy6Lzydsxz93hV/Q6ES/+9ARfp+zFhLh3B6Ltp9?=
 =?us-ascii?Q?gg1KD7wyAXvyV7ly2IowP/W0vLc4YXlxC4xBiJfgFmSi6UA2EGKmB5+QN4RJ?=
 =?us-ascii?Q?WAowk52Ws275AOcfOkadIngOtD6LAiKV1TeMLAy6GVrbdbyMrMYzZ6u0y0bS?=
 =?us-ascii?Q?em1WJCp9UGRZd6YTvcfCREPuyVJUIU1inP3gUuBvFbmzE9gb8DJowwCt1Vfs?=
 =?us-ascii?Q?YzxOHsNf9sC5Ulq/rplAMrAVzMoupVKXTpKxHz2UbkP/j9am/G6Lmf3hedBv?=
 =?us-ascii?Q?HvjqpjRDdj5bLukxwE09mZyb0eJEt60PGmMVC9vmXMI2l9tcXszm1voeEtB8?=
 =?us-ascii?Q?XHFYHrFYHw1y97T+cPITcgb58gX8aW4umNuZrx+dwJ8YoYOxNk0Bw8v1DiYX?=
 =?us-ascii?Q?Wkx/C/6ea3JAThB7VYkZRWiBx5uiHfVCt8XaECO3Choib38+Rz8AdLb+bqak?=
 =?us-ascii?Q?0+mNwefc9oITRnZ3HzxylDcRYOvXs7dVFC1CQxxb10HCLD1Bjwzhxhzzjaem?=
 =?us-ascii?Q?TfQyu9oa6Xc5y0zKX1BpXtM2v7kMltWS8kPQ25LGN3opf8MVOTkHLRDGlMVw?=
 =?us-ascii?Q?HHOFQIWGdOJskyLIKlYSqew+P/eGbWVnIMPKUZ8JqbBecJV9QE3573+tpQ6f?=
 =?us-ascii?Q?JyP60KYYpaf80MjuObiOMeAzc85N4/6JE9FDVhvnQWHAoKs8Ksleb4gOmvgl?=
 =?us-ascii?Q?7ixMkpvkMLVhiAA+6VK6Koyd5gWAcOVyfnzJTCbuKRdXkrJRkIUpQe7SLhlc?=
 =?us-ascii?Q?Gh6ruQbvOt/LAsCfy5iRTKTIapgM1UAfkkEWwKjMU5UABj+ocQqVAIoZaJOb?=
 =?us-ascii?Q?GQOUrZs2uqcegZT9rgvnfmbMPa4i5Nq31vXtpUCpyAikh4Vig4SiWv+kmqfR?=
 =?us-ascii?Q?CSECue9FKAB3pVRCPyjEGRDWFqyS2VJ2NeaeNpBZxwZfGAFYH4AiaXkDQr7c?=
 =?us-ascii?Q?ELrR3Wy7s8hALHTkjcg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b2b62e-d858-45dd-3af9-08da7409d7a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 22:04:44.7073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ljOFLIrzHJD+7EQKOKxRNLzKXkHpNudC/n0+RMlM6j9DdrgcX1qh7Zx6iGGSQOrD1LpZqAYhbz2SrenZMqwP3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hello Boris,

>> + * The RMP entry format is not architectural. The format is defined in =
PPR
>> + * Family 19h Model 01h, Rev B1 processor.
>> + */
>> +struct __packed rmpentry {

>That __packed goes...

>> +	union {
>> +		struct {
>> +			u64	assigned	: 1,
>> +				pagesize	: 1,
>> +				immutable	: 1,
>> +				rsvd1		: 9,
>> +				gpa		: 39,
>> +				asid		: 10,
>> +				vmsa		: 1,
>> +				validated	: 1,
>> +				rsvd2		: 1;
>> +		} info;
>> +		u64 low;
>> +	};
>> +	u64 high;
>> +};

>... here, at the end.

Yes, will fix that.

Thanks,
Ashish
