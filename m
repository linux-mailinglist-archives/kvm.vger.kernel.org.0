Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6144CBE74
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiCCNFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 08:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiCCNFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:05:04 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91E3517F7;
        Thu,  3 Mar 2022 05:04:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSNQB9ryThoYO+WeU5gAxxGAhj2buTi4B/Uwwi8x1b7lcHmJWeiiDtd7XrJP2YK7/5ID3+WCD/E/0LDT/E0tgp49HcTGuM0GqC5VooSlAnPtRNXGGVUkVGc3+FCJrpMhN6qdbMCPkj7grd2a+SFBs96pmk7iq21murxHYXjnOoufAxoMYnH9iz+FnOihLPHMsG8L1tDC82GNl9RTDuD9sEWihMUE9shGldUBW5QB8qwh7OWIGE0QdhDF3aZlpvwVXlzupvYqj3BlnefL8jqJF43zq9X2HR+2lF375C/taKWX/t6Cl5rOYz8VYHT+uRYlkxbkY2Nsa6ueT43FIIkVjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDQaz/E4GjTLMzh0TtDD94rYJ6jR7PnQwA+1oxWwWpw=;
 b=F2BenvFPaeexpmiwL17f1IBB/pVQipcznmrFbNRPeNaSfWnOmpb25Ez8PO8svilnVXErcgoJ/otiYUN6YE4sPdTwyn5mGndOyEsG3Ddzz6Phl2CTYc9qQC/f/cebYV0IlxGkbFSCjQf7MWuU36+hKSb99N6jM5nAO2I6NQ2vH1/OHRVllqG7IssiW2mVeFJXjltCaFaLZ9kSzv2660wUBn9CMKklKdEOhEhlwjXJcZlwaOsPBy92MoJhPjZCujon8eWXpNuzpaanEUWpCc9W9ugigYKHI6vj6NmjT9cCsv9sRswxERKg/bA054CGA9fLZA6jNB3pFsKq4lB4fEDXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDQaz/E4GjTLMzh0TtDD94rYJ6jR7PnQwA+1oxWwWpw=;
 b=UJ0VVnc8CZt4YwFbEi9OsAl+UjuVyFvfpQEqF+Kkc4LjBekDppIsaZn/RuGnWk+7obBAEkdESJmOlX9LeYXxU/TR0x2wDeNYAoVs7cM3UXqZY6L01WNMtYOjQO4PnvHwK6uDsa3iaQpk2cF1+I57AgOw70L2+FCChQPK35kArTmYUf6zsQM4hRACrn7P5AfS9aGotU697LGVeaCGM2q3pIrYk7IFQ3Q+McLv53g/YhQX7G4HKbfOxVNP5w4CeG3qPJKYwnMFIlISwEQIdvO72N9mpTE1n2V13C6Gf3hGCgrjwdm8OL/XndxUl3Eg/tVvhQ2Btb2N9zUR3OeqNogjMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4638.namprd12.prod.outlook.com (2603:10b6:208:ff::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 13:04:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 13:04:13 +0000
Date:   Thu, 3 Mar 2022 09:04:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220303130411.GY219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
 <20220303002142.GE1026713@nvidia.com>
 <19e294814f284755b207be3ba7054ec2@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e294814f284755b207be3ba7054ec2@huawei.com>
X-ClientProxiedBy: CH2PR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:610:4d::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 440c6a01-2cab-46c1-1f47-08d9fd165070
X-MS-TrafficTypeDiagnostic: MN2PR12MB4638:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4638F5E5F465D078524C9F21C2049@MN2PR12MB4638.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlyfrfoXoEHE9JR0LBtoBGcSCWEMWlf0hZKa4zpM7udu0qU2P5FyWgRE0e10Vm8aRducZWrGQoZ5ANHu9BYzQeTMPhDNgjy4JGTKmPBJlGfZ4sURfIH22g0KvNgAPrDFxfrkoMbCD2ZtZ/I+PNNYcE3Ck9LJEOghcJBDIEdMpQCggTXtM/lbcOphebTHhNFOIJoUi6qCk87h0onQx5gYQhv1oS61Tc0JYW8HwcKuWBoCeYgLZ/6UmMyr+IQ1r/npOcDNLRuxKga8KdUjkjvUfkBFohkvX2bd6TtXZ1VFUanrzl1nVxm0DWTUa2A5KRA+w6V3uGPlZH4RwtLy74CXUrbfYy7qJO1WTliVeKP+CilBiiG0Lbxw9F1L+S5S8/SI+Uk1+jGW9AogkF2NjS/KzaXT/Ee7NTHpZPsqTrYT93aB6ywXpjW17qaYCpX9+6Uh4Q+XmzelNnqFgBFcQkCRVemB+cq6Ikc+cH9DI/bPlscmUur+CY5ICGgNQwpVw0aVkG8FycKiVxqlKp4FIFzGdoTgu8T9otFIyiKj0PS5bjG88UkWax1VtqJSu9Iz7AHU++xzQrNVJNTgkSqvGEgwTpabNNCJJsGTgrd4/oH2rAQUzC34AJoNNAcysC27q0h0GjopFYuOiJC6d5UIE66u1pd6kMlcAIuI2AQP214rA6Q4DwRMDjTN1h6uNy+WK1czFmguWuxnh7gfaBfVWuOM7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(1076003)(6512007)(33656002)(6506007)(5660300002)(2616005)(316002)(36756003)(2906002)(83380400001)(66476007)(508600001)(6486002)(38100700002)(7416002)(8936002)(54906003)(4326008)(8676002)(86362001)(66946007)(53546011)(6916009)(66556008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zrDU4P/bdw+s3GdaOivhLPZvZIoxbAlBHNbFZazbe1YQxmu84QO+Ai15A2YE?=
 =?us-ascii?Q?9TjAcqFBoYX1SWbxyAsf1FYIZjenyxOslAKp/FMuSAdHqCD0XEZKw2AxLrYO?=
 =?us-ascii?Q?067ehH5jtc8pU1xOAwSrZtqTqaGgI5GvfBWK1esa4B6A+ByjnSdHK83jBHbk?=
 =?us-ascii?Q?Uw34xf57PbjqoLRpB79diKFgAZFWYZ05vpNXoEnHYFxYSOgHObTdjH+12PN9?=
 =?us-ascii?Q?OxYWyCDAuCwi40RLlZMK9mRjbKRxKWrTp3z96aDjkxfKQTA63d/byCiMCgRJ?=
 =?us-ascii?Q?CijKo5SMJgjZYxfUYgHe41fDgDZOzERNik7qeQCqKQ7eRzQJORZa0MljGTeR?=
 =?us-ascii?Q?SKHzHZUxpFq6ZeAKRVZTDCpBLsJSTISNmqqqIMcHh8wdHIEKWawjFWE2xySk?=
 =?us-ascii?Q?ADNfnCm4wJwAEWNWpgKaotsiH7PkkmSbOVLPQdxV6Uj6Ktbc4Jzr4Cs6eSQx?=
 =?us-ascii?Q?YhXRaEFivoMAlhav8skhzmNTt6+nyLFkcGFOXR/KxavsXIkG+Rw366MTBwBI?=
 =?us-ascii?Q?yOJMTbuw4iQS3ED/KILNPFsiWU3k1du2Rt7ZsW2Ohx5RiGfc77RxecOUewKU?=
 =?us-ascii?Q?Jr8CdVsFujtIGCg5sqU1e9vCvBkfUm0s93OqbgDCBR+a06QxRiH5PMTvlwAN?=
 =?us-ascii?Q?up3nWzN+BnezX3ga0hc+nPGEuXhFUMjXXuxKMJRK3R/bwj1tNVZdmX2mrIRE?=
 =?us-ascii?Q?YOBPLPBNIkddXALxqe9X+SPVYQ4o82MR/oy6EBXg71SE7nto9VCiOYI/3H4O?=
 =?us-ascii?Q?5gqGpJ8H1W+l5YIcjW/V9sluM86FAnD8ptYOMmj1EjPN3wxtfEZZYDUs0t/o?=
 =?us-ascii?Q?MmnOMXb9bkBXanaB2n+iQYq0UJma1UKwob0IdKcWKB+kqya7M/74VxjS/cnb?=
 =?us-ascii?Q?nTCx2OLdnn0L7+Abm3npsNV+jO5jyLNs0vBTIC1HbRjzT9C4lLK/sMnnjnix?=
 =?us-ascii?Q?P+JDgSLeHV9/Johgu8tcxRF2aP8Rd4rHpNXpNgDA3eAks1KBZRZtqoBPX2GA?=
 =?us-ascii?Q?PVQhlVOVBU86MaDqezpDyIq17KqK13OYOuu8to4Vo2eT3iRxA1TYj7Am6dGC?=
 =?us-ascii?Q?JmpIhgkirLqugLuZ+gBEd0ky/yipaaQwrEmiin7+yCvSB3bfiysnhWfIHPi+?=
 =?us-ascii?Q?aWIqIoASBl9MWuAQLgHPTiSyXVpeMpbthChAJ8CcVbcozOaNUlk1DH7JSCbh?=
 =?us-ascii?Q?t1ZU11phyMnC8PWbBp8NwDbY1Pu2ZNiC0KwLU1TYM1MDxmzYNfooh3DKeC00?=
 =?us-ascii?Q?HAMLlXtYmyZJEY0BnvCdiMRcc4ph5KdIT7FCEYUiEfXB7gNjYjnq4Wqo9RzQ?=
 =?us-ascii?Q?ETb4407HePQEUFuCJnCV1xQ5y67AW/P4vuankl+isd3T3N2MxpKLI3vzFy0X?=
 =?us-ascii?Q?nKnp1Y0oGR3dw6xyh33/9E8OCHOwowVabtJnDs7iyB40KyRzaquBOYoObR/J?=
 =?us-ascii?Q?maGwvW7ICgFtmh0fLTo9vbooTlPWAcJ3FR1LC9F+Zz7feZRdeMURuWthzzOB?=
 =?us-ascii?Q?XzxcMAFqHom9eDe4qOq8Hv7DwQDdGM/1yz+Hq1PgAiAXa2HrVbOyDBwGfC5+?=
 =?us-ascii?Q?4Zd4q06dWhI/yPNJujE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440c6a01-2cab-46c1-1f47-08d9fd165070
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 13:04:13.1831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lu6KoqYBHQf0TswfG3hBVCxPwCCNYGLDQm6h6j+1rvPN6b56vsmpiDNZqbtvSgSd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4638
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 12:57:29PM +0000, Shameerali Kolothum Thodi wrote:
> 
> 
> > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> > Sent: 03 March 2022 00:22
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org;
> > alex.williamson@redhat.com; cohuck@redhat.com; mgurtovoy@nvidia.com;
> > yishaih@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> > <wangzhou1@hisilicon.com>
> > Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
> > migration
> > 
> > On Wed, Mar 02, 2022 at 05:29:02PM +0000, Shameer Kolothum wrote:
> > > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > > +				       unsigned int cmd, unsigned long arg)
> > > +{
> > > +	struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(migf,
> > > +			struct hisi_acc_vf_core_device, saving_migf);
> > > +	loff_t *pos = &filp->f_pos;
> > > +	struct vfio_precopy_info info;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> > > +		return -ENOTTY;
> > > +
> > > +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> > > +
> > > +	if (copy_from_user(&info, (void __user *)arg, minsz))
> > > +		return -EFAULT;
> > > +	if (info.argsz < minsz)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&hisi_acc_vdev->state_mutex);
> > > +	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
> > > +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> > > +		return -EINVAL;
> > > +	}
> > 
> > IMHO it is easier just to check the total_length and not grab this
> > other lock
> 
> The problem with checking the total_length here is that it is possible that
> in STOP_COPY the dev is not ready and there are no more data to be transferred 
> and the total_length remains at QM_MATCH_SIZE.

Tthere is a scenario that transfers only QM_MATCH_SIZE in stop_copy?
This doesn't seem like a good idea, I think you should transfer a
positive indication 'this device is not ready' instead of truncating
the stream. A truncated stream should not be a valid stream.

ie always transfer the whole struct.

> Looks like setting the total_length = 0 in STOP_COPY is a better solution(If there are
> no other issues with that) as it will avoid grabbing the state_mutex as you
> mentioned above.

That seems really weird, I wouldn't recommend doing that..
 
Kaspm
