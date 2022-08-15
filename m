Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90FF595241
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 07:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiHPFyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 01:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiHPFye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 01:54:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCB42253AD;
        Mon, 15 Aug 2022 16:05:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCbXDrjFchgsIJkxcJbBQsqoqCDt1sq/ej9wVW3PfOnHOqRq0V8MXniPDzrWn+ZDMgySWmuku7mZ0oKoc0wF27Hu4HuAmqQJlO5gLRH4apvNLr0kRCa27P/iWkSIs70DLePnyUNaKXzbvaU87MhhEQ3WHgHoIr/3yGgSu4zsR0UXVO+IJ1/QUhrNMFzAX5KoRP7xpW69zILnlnnd45f9CcLZTdw3xn/ozHND19lmWmZeUL0kKE3f5VzYlaVlfgDg7gf1lMUqJvawKn6POwhhczpp0lYOwi0KFpXKPWkDo0mUU/F14dh36Dul+kbtJPKpgx5vEUt7VGE24Hge0tmptw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNXujW5Abg6YTWkaUrpuVSaiEbj2qQrBiWyrMxds+Hc=;
 b=f7WWSsA+KQM6JGXDSUfgGfxDTTtc1FB+ZoxPWqMEc/SNrL8dTc0g03ko7L8GrvhTX3R7yqdWAooAMz9FH/Pcup/WjdebchcSube3BDd3AZJPih83GHzU4oHCDRK6H6hplSWht1dL2ORJTRY6Py5uT8jM7s2moNLdI0iy1daA6kfXp5Gtr+1ZK0rvcGMaU/eZUcJQmQTecsaVsQEFl2LlYspesDegTnBzre9EYVgjOf17oIioDmDnO1WTMCXCTaE5C3VE1DUkm5/i1UvDdH5JS7oALJHF0etv1l9RJ/fj+EVoWOCNn79cng2s38wshQd9o1NyjAdyItr4Zb8+imSQSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNXujW5Abg6YTWkaUrpuVSaiEbj2qQrBiWyrMxds+Hc=;
 b=pJ1uNFgEac1jbcsv+nVejO9GuECfPIcQE/8RFkUosf/IJ4d13oADRh0NOUm7IteWzcMbvnRDLo2PIQrno5PNizpxJEfseiS1FbEb5YY0gU16GVHTXtTVIzUH7NjZ1lS5aXssWUw8a0oEmndSo0gSa/MHWHHYEciFAL7K4BeEi34=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM5PR12MB1610.namprd12.prod.outlook.com (2603:10b6:4:3::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.15; Mon, 15 Aug 2022 23:04:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5525.011; Mon, 15 Aug 2022
 23:04:49 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Sabin Rapan <sabrapan@amazon.com>
CC:     "ak@linux.intel.com" <ak@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "marcorr@google.com" <marcorr@google.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pgonda@google.com" <pgonda@google.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command 
Thread-Topic: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command 
Thread-Index: AQHYq/fTv45CCBlvoUerPNyckT4b4q2wjGMA
Date:   Mon, 15 Aug 2022 23:04:49 +0000
Message-ID: <SN6PR12MB2767EAECF8D4AE1C889B27548E689@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
 <20220809135535.88234-1-sabrapan@amazon.com>
In-Reply-To: <20220809135535.88234-1-sabrapan@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-15T21:58:33Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=837686d3-afc8-4692-b21d-1ab83a7b9b29;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-15T23:04:47Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: fd08155a-cfc2-4364-b42b-b47e0ca94609
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc413fb3-60ca-4b7d-201f-08da7f128de1
x-ms-traffictypediagnostic: DM5PR12MB1610:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aCVree3xiKBUV28wa4J+2/NjdIKfhw0S80fBvKRVroP9VO/g2S6w9jlNB8NI4N8Yxn86rXeIO2dh5/orkJpZC5Y7F4dE1KgQX8KnzG6BcnoSh88RSE6GQWbLJfhjaQqNb5PGP/C5NXKvwZdSrs8B90fxMiZ/MGFhjZdyVYrVwGe6/9EH9mcHJkqPCUetBq4cHE9YbrFnlKyZQQGEmU8WhzDBtMILb0lvM8LPrbmHUjrl8ubnhtjmfnfYAMXbaHQ9/CJjWcvmtbELDASBR4s/w+KPtnFRnv9T6qs2sbkgB/TMn4v21T8FJGb/NtK/KwCQiXgJkMXtwyl/U5U/e09zNNemvEX1PqIB48oSwtQpRJ+8kcRnDgo+wrtgS5WQM7CEu+SuDmGu9qng3vH/iMgq9cAAEu5HJk/XXpmsVc6gEN1ks+dt4r5LtchAEvPndJGq6KEh8pMwm55DSdfAKahxK9A/Jnuqm+kaqHaubNdRh62UbbQl9viaPT/+opxUZd6beHrX/NBq4PERUIvGnve5ffbZV9/3fHyBZvgTMs2pjINh0qSJB/0cY9L3FuuoKTwVw0ZnTADNuFzFcMlNzajXlm4rsEEhSPKWLWLN4lXZ6s0rXAnSNSaVEQkPt3atP+WJzc0noucxc7pQRoSiykrTJXS76giR6ZHAq+ePFhqlmoQSjovUTM3xHpoQzGF+wR0FJTgK8v0GxWuJWYWfDEVnU71oXor7vUa+d0Gsuccriq3gtboEhj59F8JyR5eVVTPEA8SgeOXZoLOTLBsIwbEWCjNeDTpOg6M2FH+XfCE+J5qxYAUxaRJw+HI4Vps+P4m7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(86362001)(478600001)(33656002)(6506007)(7696005)(38070700005)(26005)(4743002)(9686003)(186003)(71200400001)(41300700001)(83380400001)(55016003)(5660300002)(66446008)(76116006)(66556008)(66476007)(2906002)(4326008)(54906003)(316002)(6916009)(64756008)(8676002)(66946007)(122000001)(38100700002)(52536014)(7416002)(7406005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AsIt9POjjl3S/z6/xPPlcBbGliZVYqPEW6KX2ftIp6pnlwfnvMbvdmGahETA?=
 =?us-ascii?Q?cST6Ap91Vj9oSSTR9mT6MWPYdgYAQGQqsElH1xmIruc8s24XNPUYCl1QlLs5?=
 =?us-ascii?Q?LQ4/2BN4WyEUlKpKBa3Vzve2QGQvHIqZ74jhsrbJ2cKKjLEo32jYIbvuSfAV?=
 =?us-ascii?Q?M8WuyGaXjDEYX7eWpqayHw/rHp+qDV6MMO8AGNrlZeNj+Q2kPfmRlASezxpC?=
 =?us-ascii?Q?s46GvtZvp+2TfqXiVQQwCVE1ZfscQbk+ag46EOux2IWvaLx3jUXKGFqKXT/W?=
 =?us-ascii?Q?gk7crxcqYkUszRMIVJ7AtUtxKQTR79XAz4XL9/qgoVDSD41hWXF7XeorZSdJ?=
 =?us-ascii?Q?nmJvBbxd7ql4Dw4qtq0XbqOitIMQcRHQBEafY9e4SLybZF5d6oHGernq23pf?=
 =?us-ascii?Q?ZXmLOvKBzzCEkKAG4mLUiRxlYINIhjo22vz0NRG3ds8cqI+68Lbikx+LeNT6?=
 =?us-ascii?Q?T7UqraGsZQKkZUQr9Q8CbbYtkNs2JIkVU718CP41W/V/h/8NpMkhuRzmheyN?=
 =?us-ascii?Q?Zc+OSscS2y/8hm5yMa7oTfdkrB5mDpccJH/CPq5yhK1PZnurRXt25MSKjVxo?=
 =?us-ascii?Q?AAPZ4pvdjtcEfCAi5vK+wUCxD/f2Ex7Fpj2VkfxmlMMbfHwmym6AlXA7XS/q?=
 =?us-ascii?Q?5/4IexJFT2dVCHtpl7l/snf99OmrBr5obCf6z0lBCWJ5aeYuPe/l5hSgxk0U?=
 =?us-ascii?Q?M7ZcPYEfdE9Gzgm/bV7ueXKDoo+kE7wFPphkcKe9LripGKlnQCcv5Yodhof0?=
 =?us-ascii?Q?0xKHjRFXePdV/6CbSB3XaIK5kVAPdO//6YRYKXtXcp/yQUx6Ji/cMMoVENiN?=
 =?us-ascii?Q?GwpHCo00d43rEB1B2trNL2DQ//8I7f+2K+7dYdZCaZ+ZZQYf6ZqijF+lj/wZ?=
 =?us-ascii?Q?u3X3dDdGaW3hOs8fTIZTXKSBM9vSWdlpo1vi+NXsfoBpJNMQ1gSdbbRlngef?=
 =?us-ascii?Q?F4TuGdlpHP3TV0zlYAkXunJEMA/f0v9m29G9y/X1EK2IV/awjaSCE/w8rBDA?=
 =?us-ascii?Q?XChswfZDsl3uLufeG7NHrTTY4pR7jvicSJmUxWJlom5ckvZxFGA72JmY6qMY?=
 =?us-ascii?Q?ZyLWAkqs/q1Kh6ZCpGF/jdOAFRsdn79vbjQHXeS4tR/cBoh/rIhlqcKgLnHH?=
 =?us-ascii?Q?9cKzSwlDuqz1Exx2DKDwkNqFhE3DRAv97PrZICxxQEvWHMNsX8inIep95AWH?=
 =?us-ascii?Q?Sa1T2j3JotOtgJ5xxBLOstkt5hUQuygOPFVxJ1Yw9Gv/J23gF4bqoDTejdxL?=
 =?us-ascii?Q?ePVk9M5kxU31BHUgL5Qp/4CwVH+VcIYWPY7PCGW3BAbNMWMsBOrdIChUtxOs?=
 =?us-ascii?Q?g+OETs3M71rKheTek4U6y3aioCsrZo3xRSGLmMJfFyelNIVuC3z8OMLiZTG1?=
 =?us-ascii?Q?B68cmw7j8lLqykbBAJzNEcxSH00MOmy+7aVLjO4LB8Kcye6vghg1tn8Z/e4a?=
 =?us-ascii?Q?FNe66R3rNgb/+WJvJnJXzMACW1zIUZdCaQtImC+eVNLDIQPGqZtCA+ccAVsk?=
 =?us-ascii?Q?JI2xMbv25DAnwVL4zLcAIz6g7PGyZx7evwA36hKLwSb1wti5QYJ0kRoLVRX8?=
 =?us-ascii?Q?v9CyX4STgbH1DyLBtGY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc413fb3-60ca-4b7d-201f-08da7f128de1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 23:04:49.2514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1rdJssJ2XtrKz4OuzmHnXTRm8pwlSGNslJtoe9b04erO4o5apjdqxHCtH1G4A4DQ8UOcatdDw0MeGj/eo6ZnYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1610
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

Hello Sabin,

>> +static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)=20
>> +{
>> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
>> +	struct list_head *head =3D &sev->regions_list;
>> +	struct enc_region *i;
>> +
>> +	lockdep_assert_held(&kvm->lock);
>> +
>> +	list_for_each_entry(i, head, list) {
>> +		u64 start =3D i->uaddr;
>> +		u64 end =3D start + i->size;
>> +
>> +		if (start <=3D hva && end >=3D (hva + len))
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}

>Since KVM_MEMORY_ENCRYPT_REG_REGION should be called for every memory regi=
on the user gives to kvm, is the regions_list any different from kvm's mems=
lots?

Actually, the KVM_MEMORY_ENCRYPT_REG_REGION is being called and the regions=
_list is only being setup for the guest RAM blocks.

>> +
>> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd=20
>> +*argp) {
>> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
>> +	struct sev_data_snp_launch_update data =3D {0};
>> +	struct kvm_sev_snp_launch_update params;
>> +	unsigned long npages, pfn, n =3D 0;
>> +	int *error =3D &argp->error;
>> +	struct page **inpages;
>> +	int ret, i, level;
>> +	u64 gfn;
>> +
>> +	if (!sev_snp_guest(kvm))
>> +		return -ENOTTY;
>> +
>> +	if (!sev->snp_context)
>> +		return -EINVAL;
>> +
>> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, size=
of(params)))
>> +		return -EFAULT;
>> +
>> +	/* Verify that the specified address range is registered. */
>> +	if (!is_hva_registered(kvm, params.uaddr, params.len))
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * The userspace memory is already locked so technically we don't
>> +	 * need to lock it again. Later part of the function needs to know
>> +	 * pfn so call the sev_pin_memory() so that we can get the list of
>> +	 * pages to iterate through.
>> +	 */
>> +	inpages =3D sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
>> +	if (!inpages)
>> +		return -ENOMEM;

>sev_pin_memory will call pin_user_pages() which fails for PFNMAP vmas that=
 you would get if you use memory allocated from an IO driver.
>Using gfn_to_pfn instead will make this work with vmas backed by pages or =
raw pfn mappings.

All the guest memory is being allocated via the userspace VMM, so how and w=
here will we get memory allocated from an IO driver ?

Thanks,
Ashish
