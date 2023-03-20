Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825B96C2112
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 20:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjCTTQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 15:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjCTTQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 15:16:12 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427AA3B850;
        Mon, 20 Mar 2023 12:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFS0hxI4H1pf+i1Zw05LHATZAFSUkzQlnDJrnsAnDmWPL3+Tl8jkytnBbHqogMMTwEUE/U+x+FVkWZMMyo17R6EeI8ow+ybZLZ6wA+I0MTGjy4OT6TqorUCAPPqDN7hBUEITjBPwuhhq8JsjWWkjmFpcbKFhYt0n1CBYs4ghH6ka33vhlT4nlMQabhOz8cDXZuM+nsqs7ISPqMtE7A4HVzNCSKmgdWybHq7zOnOt1ZDPyv2bE97atvAO3+UBv5cvKu5YHCcylKyewr3UG+ySmq6ABK0iPWk/nYz++mZVc4zJopYWHFIjYVdYMZrFEtRHSoNdRTRRoSjqa7RtilBuqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtkgITDDVN/UdhLiUfKsgQVzvCsf0t3AvaJh76R8lSk=;
 b=Aum6VLDu03PuP38JSNGstYK5Ni+ZyjWsY9hEPqFLX/pK1g/EINkKI2oAyu6MHKWOmYjnzo1dwCOlroaT0VKqRoV5mOOh7+MW7xQlpWZ9ohr9a+HQoJheHYTU+B8xfi8v7vB+ucf/Sot7JKIGSpjgMJzt/plY9O27XGEFl+ufuB+xNP0xdbmBgyNjOg9JkYwFE3yVHfYlv7N174hwHh9zqof2Q7m9byh71svj+nK9NLsDvPhbzosexStl+I3yoq5cOTDp3CAigv1zVL8W1ky5A2sb69arqEPkUVyosMA8B2L1Xj6lC/4/v10OxzqBs2vHcICPt3tlOAyF0O79CCMzXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtkgITDDVN/UdhLiUfKsgQVzvCsf0t3AvaJh76R8lSk=;
 b=Y/Dj3/8/INjMmYO+u/3H3QSx7DwpQ+JlF9bhfmIBErM9urMb2OqsAnlT+sTKKYodxUURq4Q65l4997XG7jm6vxdTf8oIIxiuthq1szjNwDJBru/UBHXlJKMpc4qNzu8cJXSfT0joi4r7x/c9kmNeiZ76npMKAV+5bUGsMvdbeoTqwHsE/TqbQ9oTlorX5c+OhKH+15jXTmMKB+4Moiy+jdI4eIZVBeQR0A52AaGAaLlTbHe1jr3wZEuXsLh/OlPZGSun/VU5zi5me0O9DWa34BRO2cqvhgDR2Qb7bBr5FYY5eYaiZPsOjbXG0arjKIJgZ1nnoicmuRy2lUHmWHyjpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4489.namprd12.prod.outlook.com (2603:10b6:303:5e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:07:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:07:37 +0000
Date:   Mon, 20 Mar 2023 16:07:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset path
Message-ID: <ZBiu9+mVurbW0x5k@nvidia.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316124156.12064-7-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: 046aacf1-5586-4b19-b1e2-08db29765e73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvvEIcPqVr0fxXnRylbd8uu6OSQwMAzp5HLca9jzjs54guwS28I55Oe7/pzo8j+Hf5CRNrjFnq3JqUbHSFrShc+u3mgfaB04r5bjxf9JOb8DAUjJNojFbTVKVQeBZplLaaU/0pEXu32MFlM6jD5WRRlZ2lp2ds54PuelfuYT3Hd3JZIGF5HXdymPhvyqvGEUrsgtNzHqmYB6c79tSaIqF3yi+LzdgwbFV3noIi8bG9ioZ9dwOxcH+f1ORb8lRrVw6tvc6p87QCUeoEu7HCscatTMCkgpmdchK6/72oqufh8lYf8wU+1PdMTlJsHo22N5yh06AmnXjEdTtQ3XdE5+cI9m0s1jI1yYAl+0RHNi2lWG6hIJfFE3SgKcVqju9rnN6aKpnAVChdZP4PN2drY/giCBzrp8o/leknoEhh8G3Xp/vXrcIV9zNs5nQwxjZGgpi1RzKKR10mkFJgnKT1y3zqdd2M4U+ug5Ul/Dkez2dNQC77qQU0zQRe9CKi+JtTGrlUU9y/sn+vWrzHV7CdqwMXACoNtRfLqAhzqYsClXBqlt6V9hLNnzB0XyMbtGgoy7YJkc69JOP1RqUdvfj5eNx7ktxJ6D995irwW8dHsb1I4KyHvW5LyfHUhx0xYshxYNUyloALWDLeSR2LSH56D7QwJBCaWdSAmQXCtREQAcjUiNXoDzj+B8WQYpj5ThCR8H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199018)(38100700002)(86362001)(4744005)(316002)(8676002)(478600001)(66946007)(66476007)(66556008)(36756003)(6916009)(41300700001)(8936002)(4326008)(7416002)(5660300002)(2906002)(83380400001)(2616005)(6506007)(26005)(6512007)(186003)(6486002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VE6XnuyqOHXHnIVAYCigLYncuQ6VwpNicRffB005ETGhBkaxAhACOSzfKwjX?=
 =?us-ascii?Q?cZi0qf5ToFH3xiKGOTELj5JddCxEnUbQLe4udSZEvYB3BiCP6POtBLmekGug?=
 =?us-ascii?Q?fm37/a4ylS3GpFZOcMwSNa/sPrWjPSMMxwIz2CdMRFW2/8nllttwoEvNyV/I?=
 =?us-ascii?Q?5b8bY5D+2yuWYwToil8fJKUO68HXEX+UeglyE3+EKUnH1Q+z8ZlAOV2wreio?=
 =?us-ascii?Q?1RXav3xgaxZahdFEKf7w3mrkmriqFUqYV58xcCsqqSPDI58KhJwxB0F+qAcG?=
 =?us-ascii?Q?dL697GqKaXI5Lv/dOgx8BqulRCORMqfNtbef3qeXK9GkSyrDXAPwBqJypntj?=
 =?us-ascii?Q?MBV9KXeR+VSZpian88sBWICDH4dqDNMSerjuW5/pUGzCsebIv59oOuMeKbvI?=
 =?us-ascii?Q?3xDgYU/mjuS4QdcJYZjCLOLVJcpLlHf5ZXJmjWhaRWL75gYqY22RFHG6dnWH?=
 =?us-ascii?Q?iSGZUXI1/6N4Ww3FDOBoKiOMM4YN1FuYVmBgUprZ25uuoEDTXjFRXgIl6DAt?=
 =?us-ascii?Q?j/r3OnAT5INajMgcn4nlZSmKR7xYH8Su0pJClFg9rO7/OYaA7hjdwemsMi5X?=
 =?us-ascii?Q?MKOkGNEwfhj33yVdY7KKwmtxmWhARVyVxt8W2FSu3ftcvCPv1vUOtpZGAFgC?=
 =?us-ascii?Q?bDRIIi/RM2oC0fn2WlIjvjiq96RnBPBKJm5yPK6QFqd2cxpAhETrpjHhv9mF?=
 =?us-ascii?Q?e3nysIMtMfA4M4Mn2QsQ5tC476OBcZP+s/7sCVi/EBeZva1zdKbS4Uv6glEi?=
 =?us-ascii?Q?hliCZy43r/dFYLydLtNty2qWpM5CIEAp7HJQ0H5WnrIkmlNUXazRY5IBlkXi?=
 =?us-ascii?Q?aq71vcREJOq4qyWMzcZaMv79w3tOsMBSwZpn41JB8t2RyoLKiGK9sFFWUcYg?=
 =?us-ascii?Q?wBw0yHo6uOor2xd233p4EXwFEt+HmuGVq+eJFn6unCpSmDNon8I3aJxb2GoL?=
 =?us-ascii?Q?HpN2rvjtkT2xNCjc2sDWYHebrhOBl4em/g4MYm4j1+zaCFLNgJkYfeaghVP9?=
 =?us-ascii?Q?fI3im96BbluWiuyYdSh1DB6vLSBarRecm70NLryY4IYHsuCvnlcjILpWXLqX?=
 =?us-ascii?Q?qB9y9elCXFI6YCWItZgnT3SGkfpv9Vfs/kWNZRYNKqg9W92/2iCcHvWpZwYT?=
 =?us-ascii?Q?GXz7x6CLLWY8hPTB92hsu5qxO3RAeJzg9WfJTV7UZS0nmQ6C0tJBEadJGLl7?=
 =?us-ascii?Q?ZYL4Daqsvk6dBrjqK5ZsRByZiLUvo/d5XgzNPmuneFO0AHkT9EtNYrYM0NEb?=
 =?us-ascii?Q?EXEM7NlcY3MQC+YGYETqeUImIK1BuMLCaqC0ReOeuSiT+5E9+tkuMMmE/QcX?=
 =?us-ascii?Q?QKNrU8akEWwahSB7aMG/y6zSYRIAatCkT6hxKYbbRsyxUBl0Dn1KLklwjvhk?=
 =?us-ascii?Q?qNQJ0JJlo91XSJSwyzFLrNkcCu/R4RAFiPbpOV477jP3CwhBdME0YT0kPs9T?=
 =?us-ascii?Q?0lYDbNr4oVKRw2+Ntn30tA93wnESkHdG/cNGdrdtR84xong2E232wsc94848?=
 =?us-ascii?Q?FwC+zkAZ89HCcCdn0OxKXFs4RGt+/jEps41GU/D+inh78SIGtnfTwQFt5s49?=
 =?us-ascii?Q?NSk2jn5XkMQCWPEja511Ql/B6WkP6ZUWhuuzKP5B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046aacf1-5586-4b19-b1e2-08db29765e73
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:07:37.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lKkmOdu5TfD6nrR7yLbqvQUKQydF7LtrKSwbF29c3Gku6qcCVAzisVxvjDXx8+/N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:41:55AM -0700, Yi Liu wrote:
> This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
> device file from the vfio PCI hot reset.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index fe7446805afd..ebbb6b91a498 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1154,13 +1154,23 @@ const struct file_operations vfio_device_fops = {
>  	.mmap		= vfio_device_fops_mmap,
>  };
>  
> +static struct vfio_device *vfio_device_from_file(struct file *file)
> +{
> +	struct vfio_device *device = file->private_data;

Isn't this a df now?

> +	if (file->f_op != &vfio_device_fops)
> +		return NULL;
> +	return device;
> +}

The device has to be bound to be a security proof.

Jason
