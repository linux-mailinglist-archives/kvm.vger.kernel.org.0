Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92009587499
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 01:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiHAX5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 19:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiHAX5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 19:57:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78101EADD;
        Mon,  1 Aug 2022 16:57:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1vGG1PMBouvHN2yme5pQVNkUgJ74qHSeJIL39ASHxLAN2TVjbSdGFpzYXoQGAhRldYSzsR0LELS7VjuJj8lIgLPpgU1y8Jzb7sxw7uVb7Z3dulYQvdq3ZVIBsgAs/1Y2WFyE/qUT3fxqB4rkkjbKO/8IjV1Jknh3+M8aQb7ZyYWMlArRm3wFznhEGc6C20Rwh8BgYgv5CeuQue0p3Mh63lxUJQUzrhr6OpKvDMviJ0sFF3AaNCLDH+YSoBRPMrRBP+IYVfX0zO0KATMkhbQ780+06JfoBdIHhxqIQUOMF4qqCl5yuGKAqC5xCL5iypPCdOSW/CahpX8BcpbO4WJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgU1jCXIrboSYuiHQOEs/rxO4RPjGshxTiQ+4DumO5Q=;
 b=gaGnTVoXqle8AfIiDSSRoVL8sAaHWGq+HlQU/MiVPrm5zV4KBLK6U2g8q8O1BAi/kxM9lzzhbBWPdposO6A8syBQml5zDkj9H99DxCbgruu+lRqGLSYCUrHo+dwf9UBbu1Us7vd1BBcX1VXcj05ya8Au4TrF5ZV8PNKQ7w+wU40FhinqorAGVEuQ16izmfZhBMy51OYYrIIvX7iQCCmwLQtHBYG81BCWMiOrtIBAhddB7k0InRpLsmLGGM3fQ1v/Rn20r8n+tRObXTQonotufLThw0khS3f4MuTqWcxQ/pmzXtSQEeUScOo5unXDq8NW+zXMMPb466/ZMD3LHdLklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgU1jCXIrboSYuiHQOEs/rxO4RPjGshxTiQ+4DumO5Q=;
 b=0JFof7kqMRLAaVqaA+Dn7gaV8OdujFv9IwYr+hHdlMTa8BfUPwxX7lawelmXdoDG+qbp1AGPszbd/Yz0JMgDfZKGa0a5iD+AJ/NfTKQYG6iYuruMjkMuiLDU7+poLy9YbYyorhpiTjzeu3tSgXOk81KyMiyGQ+60uWYLDo4JOAg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 23:57:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:57:09 +0000
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
Subject: RE: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Thread-Topic: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Thread-Index: AQHYodqGKXAnBVf1LUW8LEz3aevnEK2auw9g
Date:   Mon, 1 Aug 2022 23:57:09 +0000
Message-ID: <SN6PR12MB27676E6CEDF242F2D33CA2AB8E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic>
In-Reply-To: <YuFvbm/Zck9Tr5pq@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T23:35:29Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=1e185341-d02e-489a-977f-3b541e650243;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T23:57:07Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 399d1f5a-ec20-42f8-b6d5-1f193035705f
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3f966f2-bc77-4008-82e1-08da74198ba6
x-ms-traffictypediagnostic: BN9PR12MB5340:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eybGb03BLJINGcShIyZSL4c9F7qspRTyT4q7dwuot+KqCcGtcRvmC6v9ILGkP/moYnRXMoTDn1oYEggQ9ryUXNQAP40Nwl78TFNkK2HmAFwNPwCth082B/D+tvrqyCUTx5+FgjAKuSWFp9kYqePpYXGfVlBLbWBkFLTpsC0aMIxOL9iOaLWVGHEj3AntdyKmxacX81yJDA3ElaYW8FSh2wHgYHW4jyM4QK+WyFHdI6mofl1MZSflaHzbHW/eAU91P06LsGR9D+zzwBq+NErpEiIOhbDYbR5zkvsFilorvUFz9m78KqhmSAsnGb/LekLV3DliuukjuaAzlmxhm3YCwKG708+ogS5CnDAmf5DB2LNG7iomdcMP3XGMZ6axl22oDfnvq6yl91h/F6Nn3sWH+xDS2UXiM2/5olMejlqpMy7cGXS/8idnWvpWmiQfH07G7xWaXJ5CQAdWj/EjseEixzZuifUAP/e9Zpt7QE3NdnAih/9mYr9Kl+MRNlzg5k3HqywFZ30W1J4KYc62jC15hGLVtsRmFLDy13RK42Mq6AkVoiMIoBX34IwyU7z1IsAot8omarMhQe6S8gA9cEjr5kaML/Wr3XX42cw9jQGh7mgII6wE8PO6EiSvcaQ/8PtWyUa1/4Gsw/UfxYTWFE28ESPFwxi6iAIO24mfinTxygw6QBzlKkihkcXtCuDF3LelCcMfb7Ts6x28v0wyW1cv6xmW0TKBH+q/BJzIawSeQp05wCy5YIhT0jMCsEaitFZaC8KZJTl5WRE+lc1h6BL1AlbkspsM9nGta4OowM/w1GsDOFfWB9muQ8jPp1kKrput
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(186003)(2906002)(7696005)(6506007)(86362001)(33656002)(41300700001)(26005)(38100700002)(83380400001)(38070700005)(122000001)(9686003)(71200400001)(5660300002)(54906003)(55016003)(52536014)(316002)(7416002)(7406005)(76116006)(66946007)(66556008)(66476007)(8936002)(64756008)(66446008)(8676002)(4326008)(478600001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UZoMtf/W9suC3Lk5hjDEboQ7gbZLcbALDOXL4LW1kN3epQI0QMI2Ok6sw1Hp?=
 =?us-ascii?Q?fzBKB0puVIv2+pwt4B7bSapgW3B2bMqYnn3B9L0nAD7/a9B2zMRKbO87kXJf?=
 =?us-ascii?Q?FcLDwLL0VB+82JqbWf45hONm4dDqvek1F5NPvn8TNdFI60KSRAxp9K09CE35?=
 =?us-ascii?Q?jpSa5taZOlBdfzSn5OdI6Y8fiIDpzk4ImNxQCtVoidjMFTB31a49IqQ6eAjx?=
 =?us-ascii?Q?xgVgAq6VGqQzWOPdKw2Mze/BWLKpEr25gqp8xxXvkNhbshKUUB8jHeGF3ej4?=
 =?us-ascii?Q?ohnDBZkUEWbbeyEyvC+rx1y2t/BzSMQdRXCZ6BEv3E6qXNLREDsVfQUV+1JJ?=
 =?us-ascii?Q?P1eZ1IFmB75KI+vsyIfn/SX1c5OQtAWI1LHkSxCadJZNOlmGUIkUVUKZxVmr?=
 =?us-ascii?Q?GKgyHQkXL6mGXtBDZ2Buclkzxggxqo6HjgsqCjD2TIHwy8tqOf1Z283rIz2B?=
 =?us-ascii?Q?PYRwKuKH1gDiS002r1fnaXiglEa+DmXgFB83ajdQbR8pfka98cGpZgCa251/?=
 =?us-ascii?Q?eJ5NterByWclANvdBeNKl1QVG7jD3M9wzyUgipuTOFnjZwQ8R1wizJImVR+m?=
 =?us-ascii?Q?okv1fGKjPknP59rddBrAYm+NnTNOD33q9GXhY6l3avG5XDqCRLCdlIzKXK4E?=
 =?us-ascii?Q?3kVCJt7fqJIGSIGUXTeGR59bTO6oPFfukSwGxBfIFPSScmLcOohUe190x66R?=
 =?us-ascii?Q?zvLvubvK2Nj0YC+UIqrEbQR21dwidf2HXZzhym7ZwEL89DOIp/7G66z0LwfK?=
 =?us-ascii?Q?2PMR7oWMPb78Qji4fHZPHp084sjiz5s52Yy4fH/evsoSdLWv88lWNsthpSPQ?=
 =?us-ascii?Q?wlTKiyQUZ4OBtpkJ17WCoDhM9KOZ9XMpp8DrwHDQn70OZnhqVLZ+Z5Vy4e4j?=
 =?us-ascii?Q?HCzOEzo5VVNTsxSisECM+OLJ0JuuqcyzdCvBrEYLxQwvyexp1NfIIi+c+M8Z?=
 =?us-ascii?Q?o83wYdyHJM7ZZZzM5MD/hBwGfpgbQbxt6iWPqdQcWX7YsDvJG+T8LCdOxhfT?=
 =?us-ascii?Q?MPMmfwnqm+NLuu09WLterfub8aUY0F080+B4uJLQh22wyPHeXC1G6p0w7BkV?=
 =?us-ascii?Q?cxdXMyttqyyRaF3PBP7LS0/nR9aH6o5w1At7EX5GFGWK/O+kQkH8Q2hqkUnM?=
 =?us-ascii?Q?RyfnW5jsvjmu0wYlZocGzHYphzJdJjoCEGCc4jiK2TPvSl5G0I1B2uVwDoVi?=
 =?us-ascii?Q?Hw87Sr13UqSspKI8ROjZIYV4cptouhI4CqDzfVgYzM3sCause4ADx2erOCSw?=
 =?us-ascii?Q?InjXTP0hC27hHpIVvvE6UV0Dg52c1mT4luomfp/fPVHXO81CE3E1KF3bnPll?=
 =?us-ascii?Q?JOmU54Ezx96AJ1CGGECwzcilxf4sglM3OaHFF3LGW/mHeyjzJ3QGzvQNWtT8?=
 =?us-ascii?Q?nq02w40qjO30qukaBqibS7hZtoyMVFFrHlnrgoKCxVAAy83zX+7GTy+FQbNp?=
 =?us-ascii?Q?hiseHZkEtiVQQyFvDhle3iHTeij/QEoRkatHl+XyQEc7dv5799Ry4KscwRa9?=
 =?us-ascii?Q?q2C+2VI5PgmVwTBcuTQvsZ5oeWjHZsngEGEPAqluVMV6ESyd88snPwVKivvZ?=
 =?us-ascii?Q?BNSdDexhP1wqYD+EJEg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f966f2-bc77-4008-82e1-08da74198ba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 23:57:09.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RET/0UFOIkq/QMmRbCassriQyxKTpRIgtINRR8VBw/NdEDv+CQlJrJWdmjB5zCYKnzC4CyS4zX55w62E3x3gdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5340
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

>> Subject: x86/sev: Invalid pages from direct map when adding it to RMP=20
>> table

>"...: Invalidate pages from the direct map when adding them to the RMP tab=
le"
Ok

>> +static int restore_direct_map(u64 pfn, int npages) {
>> +	int i, ret =3D 0;
>> +
>> +	for (i =3D 0; i < npages; i++) {
>> +		ret =3D set_direct_map_default_noflush(pfn_to_page(pfn + i));

>set_memory_p() ?

You mean set_memory_present() ?=20

Is there an issue with not using set_direct_map_default_noflush(), it is ea=
sier to correlate with
this function and it's functionality of restoring the page in the kernel di=
rect map ?

> +		if (ret)
> +			goto cleanup;
> +	}
> +
> +cleanup:
> +	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn +=20
> +i);

>Warn for each pfn?!

>That'll flood dmesg mightily.

> +	return ret;
> +}
> +
> +static int invalid_direct_map(unsigned long pfn, int npages) {
> +	int i, ret =3D 0;
> +
> +	for (i =3D 0; i < npages; i++) {
> +		ret =3D set_direct_map_invalid_noflush(pfn_to_page(pfn + i));

>As above, set_memory_np() doesn't work here instead of looping over each p=
age?

Yes, set_memory_np() looks more efficient to use instead of looping over ea=
ch page.

But again, calling set_direct_map_invalid_noflush() is easier to understand=
 from the
calling function's point of view as it correlates to the functionality of i=
nvalidating the=20
page from kernel direct map ?=20

>> +	if (val->assigned) {
>> +		if (invalid_direct_map(pfn, npages)) {
>. +			pr_err("Failed to unmap pfn 0x%llx pages %d from direct_map\n",

>"Failed to unmap %d pages at pfn 0x... from the direct map\n"
Ok.

>> +	if (!ret && !val->assigned) {
>> +		if (restore_direct_map(pfn, npages)) {
>> +			pr_err("Failed to map pfn 0x%llx pages %d in direct_map\n",

>"Failed to map %d pages at pfn 0x... into the direct map\n"
Ok.

Thanks,
Ashish
