Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449F4567059
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 16:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiGEOHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 10:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiGEOHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 10:07:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D257D2251C;
        Tue,  5 Jul 2022 06:56:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KS+3TAcW5RAFU2Bn3jykVqkG32hGjVNDsdfUhH8VZKgTlNnqEvCyM1qqgb5N3DZgtbX3pHQy1UsNUtNz7pYIRUfN/0NBRjAhJNfwFqQjAGYs+m8zxJRK4JyHyFBqBdr7vUfQGh5rLyJOqn/pRYn3kn01NqjhpP/79KA0T6ROmXgwRwVPc6cr3srevWr2UZUw3s+fCE+xPj6XI96Shu2rz17wSYqwNIUP7DZv4RdoS/cEaeC54I/mnDk3iqeKlhYglhm/JozNH5hoZc4UY/PNjOjvtT6GbpEliDGOVNvdq/qeKXf47Bi/QyHuknMKkfkIPpyDZc4BoZxfSUPKSU8yxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAiLVebQhyB2lpNSVBGxV1BPOMPRAA6nZwi28M9yDpQ=;
 b=MARtPV5ii7vd/7Qrt2KGtn/3QPwAimJRHPCiYgxo5xwWaQgIv7n1lux8YcsokffrV0sJzxhxohcgQR730cJ7dLnJx+o3qKS2BwYjzYEXJwsBrPsCrtTOe+iPuXDuu0mB5sHJED6b10bQQNQKIpDaF+4+Hb0suQBJRv38L7tKzpc/MQmd937/cm+va5/B9pil8u1X89xr0aJfjei5ubwTV3Ovl4z2/I9rXLtG1z+Itym3aeU5jnNYhayp23knn47+7SuXMaQaKAbTfpsUl5fJ1FjrHOMF/yRa/pyqZZ2us/7uMjNMuKBTVpPIoLeHMeTxc7Y2lov8SzzqLI0Tns8NJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAiLVebQhyB2lpNSVBGxV1BPOMPRAA6nZwi28M9yDpQ=;
 b=dtA8ogFTYZ9n7SndFfxRA8KkQJBQUrkNAT6bbLWZG6Z6guHFNYeNMexTy8uWCYlYeAeu9K8MkTlbjLyPFYmD8BVsqOuV1hWJLsmD3v1uZ0OmqaPrc4Psvu2zZ4a7Nxukn2KyikH9V20YDjruepCxL4Mo8Hvf39f0lz4Rx1BUdzw=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 13:56:01 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 13:56:00 +0000
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
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
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
Subject: RE: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Topic: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Index: AQHYjTdG/Jq12JdNiEyvNHxMVTEAQ61v0QXg
Date:   Tue, 5 Jul 2022 13:56:00 +0000
Message-ID: <SN6PR12MB27673AC95A577D5468A949598E819@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <Yr7Pm/E9WsAjirV0@zn.tnic>
In-Reply-To: <Yr7Pm/E9WsAjirV0@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-05T13:47:12Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=72928229-1ee3-4f8c-9dbf-f91643fa79cc;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-05T13:55:58Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 88abcc46-2c3f-42c1-a93d-0c5982b903a0
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21cfac18-9723-4053-f895-08da5e8e1811
x-ms-traffictypediagnostic: MN0PR12MB6149:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HZOcC+g1dK0CkrQa6YWflR3P3Aj92ue+500EtmGiMN+J5hRCK4GIhzKNOTT+7KZqqQOEMeFfpIJffgBeV5TXixLfbvF9od9+zy2+zSLGARoelbxfJBldEkvCcOyGHIXGd99ctvid1M/6+TJSSFvzmJq5lTlT48DNA53ZwJK8DUaCZbS0vP15Fxd613Kht1kpCXiiP9jhbgLDa5dt2+c1oA7v4Yt19TeSfyFhifRCZJ2amDzseTa2KlgQdJ2szAHAVLRU3O6fvHD4ORS/JsTirbQYvEYBtzf3Zk5EPut1B30+/2J8vWZKv0GqlCi3mn7abBAjgRULaLvmSBOrPV7/uCyfjKjuIwqndUQbu8R/JW2fmbLkYHRTrxXL0QcGzNDU+0vyqV3UhHIjW6oqiN2ne0kDvgtpreNBFrLcHYcymtW7EFoD7CeOxtOHOmc89T738gV3MzfXdUE75TtK61Iwv78Q9xTVz8+hGB8gDp4KxYyq7TEf9RkGPI5+d1HnRi2tN8bG3UTOkaPX4fsv6z2aNgY5S9UFLOzDXhuOWZj2zTUcjPSzDQxWS0t8KYs5qZ1m1Z5xyFTSdAmFVAF7oWnXeEkxlLLPgQ6FZ4W12/l/JnFkGXWdAmB+rLuDPZWHyWgK8/J7+MfBk28G1BxNPCW3v5XnRfh8VUB11tfWNgBPLNYS2Q+yjtViGfr4ppjOQPPQa6aKkcTsD9scaCWol2elbPgl4ilnZruiq7MU0QSt+LNqeBnpI2QmcSqMInIYucmSVz8iuSBD37/hI9mYH3pEeswfgtWT9ihTJImoN/QHiHfYUbjsyXMfvDBDLgSB4MhA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(52536014)(8936002)(7416002)(7406005)(5660300002)(54906003)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(86362001)(41300700001)(6916009)(316002)(71200400001)(186003)(38070700005)(26005)(9686003)(7696005)(6506007)(2906002)(122000001)(38100700002)(55016003)(33656002)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wdm/Y9r5sphXB+Ko2k4CTwHCBjJDvvj2rI+/u6HVyIlptb/l2kXl3XrBLRn9?=
 =?us-ascii?Q?H3CnJeKvgO1O/aXKXJ7OsGk+uYjqTv78V7xQt++kfjhQstQwcFwlnBcEVAw5?=
 =?us-ascii?Q?53i/qrNQk6Ik+V/y7R7V0O6xy6WCGVPbQr1Nyr5UWjsSTn8D3QgxqkNz0jiy?=
 =?us-ascii?Q?O+1hGmbg5dnNJNvmhZxhUV6Bxnwf631XH5fTll38BC/ng9cQ5qoMw4aYCni+?=
 =?us-ascii?Q?cPV92t4k2gLblYiA/acTBj1KnMNnn3K4wTv5psdOCHLRWVb/BA5Mw1WRzYMx?=
 =?us-ascii?Q?+1mmsZeZx9IZ2JdlO2sAsuJNW6oPTxxTrIQahiF7TAvGpl/P5p9NvvNoo9GT?=
 =?us-ascii?Q?yIhZkp1SrYjIacOQqCaf/Lad1+vKNOIuTv54x8K/xomztH/mewwQkOMGqBPd?=
 =?us-ascii?Q?ocip4pHRfQmvTsVmnavQKFEX7RRDZMsx250kleDNnqs+CMcaPKYd0BMvSIqs?=
 =?us-ascii?Q?sdaSlQlURNG/Y19OxcHiB33BXrWyVAXzIg1dwElJP/HgHkBWIhoLetl/IvQS?=
 =?us-ascii?Q?igkmQXvoqvNjBYryM/eAvCdlbew6GVVIxj4XfDWhbmBeUaDB/EVLQcJKi5ZV?=
 =?us-ascii?Q?W8io7kz3RsqrZRIBbzuEiQLduk4O96M2KnpMP4talzmijC0lkYgYwzaRqwFb?=
 =?us-ascii?Q?J+bYXq+iUImfjZZtYyXnhD6yANzQRsSes2zRw3OyBcwqZQoNt/3SDH/3Fnl+?=
 =?us-ascii?Q?pyAc5BsAMwoygrc/jwe4c0PPTTciCpeaigY6HvfKx7aoqnv98s4LEuV2ZJH9?=
 =?us-ascii?Q?F+9Lhki2WwvNRHhpxcxuXOmNlckUBdap8uCa7kbtVnMnC537FljF6qKL3nQO?=
 =?us-ascii?Q?tY5H+cRjeBlRN1iUcpIa/W0shRsWhtqVdUZE5KxXflW8SBT6goZjdftGRkc6?=
 =?us-ascii?Q?ck1w0Agd3HmiGPk4b1wGF+cAIIaJ3dqo+jpKcD6MpvjucKlq707BxzOR19d6?=
 =?us-ascii?Q?I9JXwA55321N/avJW19KqDRSgFq3wa5Rfxm/mrDiJr3/nONY+kWHOs4JIh+D?=
 =?us-ascii?Q?zAXRqQroQoKVz3xiZxK0koyBJtY3MDFJRoLx0ixbhZo3vEY1Rs1Il9nX4+wU?=
 =?us-ascii?Q?SxNLAT6lejcABe4AfIELp1bq/0xEcyF6vPy+C2m2GhgU9JKGFnKB511YMQ79?=
 =?us-ascii?Q?BZ4UUfha3Czadt0PFTjtTZItWdPOQg00t1CopSOJItwji7uMq7a1qav27vEv?=
 =?us-ascii?Q?MWQKzcp73qXlOCBdkLudzRpbvxSCWDgbY7HbJ4SmPnMWt9uqhs7qHElnf3Dn?=
 =?us-ascii?Q?7b32+vK3HqPKr1acdTIy2KeL80ZcVbq9qMWHG1Jwih3IX9hHhr4wVeEs/WmP?=
 =?us-ascii?Q?kgsBtsZxifyG08fAYxT8zg3l0g4/5/XfgurgS1UGTUiXni1den47bsMbAxvX?=
 =?us-ascii?Q?Nyvk5JFzlyAiyfgP0I9nvm6o55ljgNPplGfv9meYkD6rAL09YZnjIxKp9mOq?=
 =?us-ascii?Q?bNuQjLmGQjz2nk6wsXR/bG9VvVvZM4YRCjVM7qKEYWPexW1qHyvkEEcLitFW?=
 =?us-ascii?Q?5BF0k9mQ4aNWzQWnUc/dYEn42kXkPXpjXLf8QT3bTEywhrewe5zIqV0oa0ch?=
 =?us-ascii?Q?oqf5NVgaZ5M79RVRP7w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cfac18-9723-4053-f895-08da5e8e1811
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 13:56:00.8388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3IIzK/uViy1/vzuLDs/4vD5HN8RnLcWXAjxf4eb6PgF8jxnxyciAqT3Sc0c0yYJ4jrjxZ3prK5PN0coyCfqjww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149
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

>> +bool iommu_sev_snp_supported(void)
>> +{
>> +	struct amd_iommu *iommu;
>> +
>> +	/*
>> +	 * The SEV-SNP support requires that IOMMU must be enabled, and is
>> +	 * not configured in the passthrough mode.
>> +	 */
>> +	if (no_iommu || iommu_default_passthrough()) {
>> +		pr_err("SEV-SNP: IOMMU is either disabled or configured in passthroug=
h mode.\n");
>> +		return false;
>> +	}
>> +
>> +	/*
>> +	 * Iterate through all the IOMMUs and verify the SNPSup feature is
>> +	 * enabled.
>> +	 */
>> +	for_each_iommu(iommu) {
>> +		if (!iommu_feature(iommu, FEATURE_SNP)) {
>> +			pr_err("SNPSup is disabled (devid: %02x:%02x.%x)\n",
>> +			       PCI_BUS_NUM(iommu->devid), PCI_SLOT(iommu->devid),
>> +			       PCI_FUNC(iommu->devid));
>> +			return false;
>> +		}
>> +	}
>> +
>> +	return true;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_sev_snp_supported);

> Why is this function exported?

This function is required to ensure that IOMMU supports the SEV-SNP feature=
 before enabling the SNP feature
and calling SNP_INIT. This IOMMU support check is done in the AMD IOMMU dri=
ver with the=20
iommu_sev_snp_supported() function so it is exported by the IOMMU driver an=
d called by sev module
later for SNP initialization in snp_rmptable_init().=20

Thanks,
Ashish
