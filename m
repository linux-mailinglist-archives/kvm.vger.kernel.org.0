Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310D8698B6D
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 05:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBPEkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 23:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPEkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 23:40:23 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2100.outbound.protection.outlook.com [40.107.93.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E35628222;
        Wed, 15 Feb 2023 20:40:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSOcOiUTrMsNpF6nStSF6h+F5d5uMqKYeNK0+H3xYG6ucZBlLDyus48pxJJhNfNARsvHIkxB4NBpeW8+vcFgPrKw5bsWgG0fGNmX/NIDfkNvahG0Mq23sHE8DwlGPBjH6BM+BMD0t9bYast/oCGRrrnF7kS7C0BeAfjvnRS7gavcHmYVYIHSyejfn7pgSw5UHJ9f5pp3uMDeaWIqq7s1r+SAU5k6RLL6ch96HndiBlScgfSoT7xRQQrlMz4hdegLxhpvJY6dN2+4HwfyKfU9W3v8Zgwnlfo6s9+CTn6ZazD9t8lzYh0iGGYdZybvhxiEh7ySwG4l1DuCVCCAso2ZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcKBmIL/BZUT3aPoeTK7G7VQkRe+PAHXWxz283a5MN0=;
 b=CqdH8LBEUDKe6GkI90uPWvfkKACZr5GtCjWMfN9yqTbaCz7+OwsYCp/TVwmHjLzH5ZQ9u/C48UnRB1bwl4fXc42iZP01eo+yZqZELWvnxRESp1QAjVDGNyFnjSVNakhXHOmUyZesfwSFsFBi0wexcm7Rh1TNyt1ppRroimMq5GYaQRZuxA5eShPBbO3RBAO6QU5AMZa5lzQNLmkXxrudKlfz0z/yvSvV2UEOdCtXMtHDxiLp7+4vrsEmQmn05GzH5fuLPuTRO7s4mjgTnYm1tOHyE8uIOvKCRo6Yv8PVY1WKM4gqIsNLqo4QxAKc2AZFQujwu1tGK4pPFRhBacQzwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcKBmIL/BZUT3aPoeTK7G7VQkRe+PAHXWxz283a5MN0=;
 b=DBlIPz2YSLxc+sXz4scX2iFUNI5KmQRvf1ChEL3VS3AS+VtQCEN38b886OK2Ox/B7K5/yE1+xQfFTWn0fDuqxBHPgVmZYia7HUNwdMBNZTNr4TytiTkUq2AGXP/IhOzHBLr8c8DAuhP8FQEmAXp3H8RQoTeCa1othgWUgqZMEgI=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by SA1PR21MB2051.namprd21.prod.outlook.com (2603:10b6:806:1b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Thu, 16 Feb
 2023 04:40:15 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::3747:daf4:7cc9:5ba2]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::3747:daf4:7cc9:5ba2%3]) with mapi id 15.20.6134.006; Thu, 16 Feb 2023
 04:40:15 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "sandipan.das@amd.com" <sandipan.das@amd.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        "ray.huang@amd.com" <ray.huang@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Thread-Topic: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Thread-Index: AdlBv/2siHbGoHczQeyMVKtAUkBIZw==
Date:   Thu, 16 Feb 2023 04:40:14 +0000
Message-ID: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=58befa47-fe37-44a6-b515-533a56ad9479;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-16T04:07:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|SA1PR21MB2051:EE_
x-ms-office365-filtering-correlation-id: 7ca0acdf-57c4-4040-c026-08db0fd7e575
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lP9AfSp6MJ7I/JfZ34euVeQt4Rz0rNUh04D7+bMMTwh7GvScYx35FE/Py571whsJNAXgU00XPnNKEpo3+AEG9n+pxX2VRarb9fTE+ilANnjXs7H2PlvkwLm21Q8SEE2w/veIIuU0wWPH2CGL1YVsfE9+luNFFZclJv8VXy3vApkjMuC2vHNuwdULSJ86BfG8dQbdZAO4Agi/tFGiNF8yaroIuBbz0vKjpYeHfZLJUEfEOMyrXA1Qyvc2wxhB4BevJ8Z0nu/gdo4V6gdCuGBPSFSFg4BhmL1nxjJ0IJD5s+SPkND+USijqQ1d0YU+nJ4UQ9f2CbEY8nH+NeRpWw+t850BPDvGcW57Dye9daGGM8rBJGN85dMODqwf35ycITdklMCO6/AccufDhrfGE+OdyhhuNIWI1i/WHZiL3Bhce9zw1ki0sE8iGc+LHB0pJG9DWi2yqIXOEyN3fDgemNPExhdVD9QytIam/K+FapD+OAw41/kJoMEP7seZvQnq3qTieTgVMdT1iMVg0hlCwukwyeiYTIwyjYfXf4t5wBqE/LysdF+74Rhm6jIzKYyXy5Fxsx2vatzWEStsspqWI3cPHi/2t7qi5SwN3xWK8D8QgVbVXqdXvPilXzU9Zi8QfO7ZUlJQ55iWhm84JDACpF0xZGyk5E/uVF5/+tt5Obq8OCxIbVnWZlGmEAaKoEpsvlG+PVXBT4dzOVm4+w8Q4rN8B0XnNgjTAPCX62mlwjOVJGiGDGY9ZhMq9QuVf8eZXkmqY9AV9k7PXDrIijMty8f8cQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199018)(110136005)(5660300002)(8936002)(82950400001)(122000001)(82960400001)(54906003)(38100700002)(83380400001)(26005)(71200400001)(7696005)(478600001)(186003)(9686003)(4326008)(8676002)(2906002)(33656002)(66476007)(64756008)(921005)(41300700001)(7416002)(66446008)(66946007)(66556008)(38070700005)(52536014)(10290500003)(86362001)(316002)(55016003)(76116006)(6506007)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?14r7H2cAi9Ye9syIdOc7i/gLQdFmT+EjnwW5s2g9snN2UNOFwKSLRiCjzOo7?=
 =?us-ascii?Q?UEYbXXFbE9XASXV5FjEqzDUwamDz/F+UH6R6FsL70NX9lfSca80VVFjX4wy+?=
 =?us-ascii?Q?Cu8NvP5r/LNhjzvUyukbf943r6X3sb1jhL2TWQj+S6W4+00/EfRmeYtSRkL+?=
 =?us-ascii?Q?tnO54tdCqSLIUf/CtTRRGd3BCHmHtv/q3G3u5dDbECbprpTlUF9lcJoTAeDa?=
 =?us-ascii?Q?sblqlpZ0HgICmnuDTZ2Vg8RpHBCoHjzZdA1wDWJU2vHFGCi+p/KGEuoda5R8?=
 =?us-ascii?Q?35PUGWK9PpFzuoEHtldxwwruZlSIXzX1gR84pZjzKVeqb51N6ZpryCb74WTE?=
 =?us-ascii?Q?1G5/DoLJDG19Rh/HA7I4Oxi1Cj+SpOaNzB87jzoZGfXpS2soJ8KItiY2ytP0?=
 =?us-ascii?Q?YdaOYYtQE+MnPNRCnwRxmvv9VgTfn9ddfkQj0ghsQ7lcUJGsftjv2ybCkErX?=
 =?us-ascii?Q?EOTdhYr6uCq7xu2J3Z1MuCkpF63S/AEpp0f9VPOLVUqFXBfn/o6VRhCkDa0F?=
 =?us-ascii?Q?BE+meETLPJIYQwm843+JGP1TjOSfiu45DkmEuRJMX5PrYIvsn8lNtK0pbCtn?=
 =?us-ascii?Q?Jm1f7zLAXIEESqeUdhPb63XUt6/ym7cMzWx9JnIaERIFgjxhZcq6+lITV5Zs?=
 =?us-ascii?Q?IcyZhmTP3X/zFwYMVlGS6CT4dy79vRLsASzAMhSt7g1CHInUXnVm1BV7b2Qa?=
 =?us-ascii?Q?LtGYBPRguDfpzvcNyygChSwDxU2RB2eBo2Ar8skCdKNQPJf6iuT3Ubh9+mWO?=
 =?us-ascii?Q?sfBJD6wS/QgiMUKnswcJ+16FDoGUv2Z/Ui8K2P+VQQDkybqe9fJrBrJunL0K?=
 =?us-ascii?Q?y2zjG4RYP0PwsOVPB9dOO9LA0CZKQh3bq7prSI0c9VS9b2oJXeHa1E7y0wJq?=
 =?us-ascii?Q?PC0LF3Qlp7aObYENl5ww1SBB++8Sc9Enpr29p9g7KeG7swixOsL9rxMSII+j?=
 =?us-ascii?Q?Lnvgdoz4rsLWRFvHTX1LzeS3R97ZGfGmDgAjeGdmkw16TloXnJibT4BX2qJd?=
 =?us-ascii?Q?a2MCfZ6NUCYkmFEk9/l5j03DU2PuOjDvZpUTzt4dddIL9WcZx0yTh2vOuEMt?=
 =?us-ascii?Q?EVLTZBDhq1nbvekzv+nM+gu/nQ0SF4dULSyLrB9mbkJ/n2fL8ySL1YbHhMO1?=
 =?us-ascii?Q?soRrKGmHjfPFXF0jLrvHqelCi6pWGKC/OIqrXDBrawM8p8o48qVi76M0+l13?=
 =?us-ascii?Q?2/fWQOP0X+5mTCgzjFwXjufW96z0bZrGXuMfVlWtL1Db6lOa5oIhtdaz4SXf?=
 =?us-ascii?Q?D8bBujsveFRZa+iDlq2/z59FpJTWnjBctYuPf//3TsUmqGBcv4qabPIkzcgf?=
 =?us-ascii?Q?XSwX+X0RcSu5ORtihUFUYZXobNhurGGjrMLHJHVvk2bDY6SNrhmTSShiJMt0?=
 =?us-ascii?Q?VO9090aC69dLnCkPqOtyHCdaWj8rrxHUTNyrJqsiCqlrgVFfkOdVU1+BMIkb?=
 =?us-ascii?Q?bycvQ+9PGGPq8Q3NXXij8utB1R0Kt8ZgURjuamBHJlLIl3qtuDW2p85VJwPi?=
 =?us-ascii?Q?dFyBVfhfN1W2UYp5s3rYALxfa2OPnKu8Z4mLOf+7+51v1FXGT0mrXkYuhIX1?=
 =?us-ascii?Q?W8ETpbQFJbU5EUvCREzut58yNQOSYLdxuOgKrc9t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca0acdf-57c4-4040-c026-08db0fd7e575
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 04:40:14.4673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rr3VVJNAJ/1RJf+fDHmyBlhvpPmFaRg+yuibVu+90wXd+2V5oFRXABQNpfv8+ZwAf2M3SfAZL4q5BTXC2QsGgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB2051
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,
With the earlyprintk=3DttyS0 kernel parameter, a C-bit mode Linux SNP guest
on Hyper-V always decides to crash via sev_es_terminate() in
do_boot_stage2_vc(), because early_setup_ghcb() fails:

early_setup_ghcb() ->
  set_page_decrypted() ->
    set_clr_page_flags() ->
      split_large_pmd() ->
        alloc_pgt_page() fails to allocate memory.

static void *alloc_pgt_page(void *context)
{
...
        /* Validate there is space available for a new page. */
        if (pages->pgt_buf_offset >=3D pages->pgt_buf_size) {
  ...
              return NULL;
        }
...
}

alloc_pgt_page() fails to allocate memory because both
pages->pgt_buf_offset and pages->pgt_buf_size are zero.


pgt_data.pgt_buf_size is zero because of this line in
initialize_identity_maps()
     pgt_data.pgt_buf_size =3D BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;

void initialize_identity_maps(void *rmode)
{
...
        top_level_pgt =3D read_cr3_pa();
        if (p4d_offset((pgd_t *)top_level_pgt, 0) =3D=3D (p4d_t *)_pgtable)=
 {
                pgt_data.pgt_buf =3D _pgtable + BOOT_INIT_PGT_SIZE;
                pgt_data.pgt_buf_size =3D BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZ=
E;
                memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
        } else {
                pgt_data.pgt_buf =3D _pgtable;
                pgt_data.pgt_buf_size =3D BOOT_PGT_SIZE;
                memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
                top_level_pgt =3D (unsigned long)alloc_pgt_page(&pgt_data);
        }

In arch/x86/include/asm/boot.h, BOOT_PGT_SIZE equals
BOOT_INIT_PGT_SIZE if CONFIG_RANDOMIZE_BASE is not defined=20
(which is my case):
=20
# define BOOT_INIT_PGT_SIZE     (6*4096)

# ifdef CONFIG_RANDOMIZE_BASE
...
#  ifdef CONFIG_X86_VERBOSE_BOOTUP
#   define BOOT_PGT_SIZE        (19*4096)
#  else /* !CONFIG_X86_VERBOSE_BOOTUP */
#   define BOOT_PGT_SIZE        (17*4096)
#  endif
# else /* !CONFIG_RANDOMIZE_BASE */
#  define BOOT_PGT_SIZE         BOOT_INIT_PGT_SIZE
# endif

I think this means: if CONFIG_RANDOMIZE_BASE is not defined,
earlyprintk=3DttyS0 also doesn't work for an SNP guest on KVM?=20
Sorry I don't have a KVM environment at hand to test it.

If I define CONFIG_RANDOMIZE_BASE, my C-bit mode SNP guest crashes
even ealier -- it looks like CONFIG_RANDOMIZE_BASE is incompatible
with my guest on Hyper-V due to some reason I don't know.

Do you always use CONFIG_RANDOMIZE_BASE for a SNP guest on KVM
and does earlyprintk=3DttyS0 work for you?

Can you please share your thoughts? Thanks!

Thanks,
-- Dexuan
