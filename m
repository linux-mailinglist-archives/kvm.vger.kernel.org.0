Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA226BA46E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 02:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCOBBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 21:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCOBBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 21:01:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43F65A903;
        Tue, 14 Mar 2023 18:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY1TRznUzpJVdcFzMdclMfqQbnr1S9zy31bEPx1Hq8nx6rnJewC3syZHLaqxmUa527UuAcqXPQ/QvBP+A3Exq0Ewx5b34bcphHC6L4UmQztsb6kpyZCp18+fzlXISmKfxDFnSGpnDz1/BreKDH8wq1LJ4D8OKmyzFaOVjZGHOweygHrFXW+hT5hSVz/QpDJAVwR0JtdRNoGI2Ay7OLwssMROW37jJwgwwPmVjx5M+FXX/fpom1jlxbSN3OoEuvAOgovhE4J5qAalKtoa+pCecAJXYKuYce/xl4A1A/Ouw0S2PVA4DOlmaph3zY02zF13bYuar4w8ow7bHBxtDZPBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+3snqGfsPmlCiRJCCt35YcV4ZAIFEvAtJrCTvyN+Yg=;
 b=i1xAI1tXk/ZiBPMQKDMt7uzpRHgZ3DXQ7DYBg6XC0zxCl+EUPg8xNKETAfVge8Iuq1bL9aIkvb1y3IhlUAocceWn6kxaPzY/TOXljMqMsVr+Zug12PLp4R5LaR8SjTUzxIpLfBf8uaJmxNdcJvYoryBCQoSjIlbaZR9ayORljktUXI0tkMaAx3gYwpDxTosPdg3DNQ/Lr6haGFB1ku5fixZlTjf6AupdnruyDIMq+KcFxkG0c203QtpHaWSdYDTZubVGkqJrTsjB6GMVDCwqzwe4Vodom+kn3TJcUWm1EP4qsUdhHgJ+m5AB+bRzpOzM2FLNeVIOvrWjkndXFE5q5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+3snqGfsPmlCiRJCCt35YcV4ZAIFEvAtJrCTvyN+Yg=;
 b=fCdpJiX8e7J2BSF8BoedOqQdlsKRN+Gf0kOmdg0ERBsGsIDl2H9gNJU7TogstgNOT1j8sKsi0yd0w7YY7QzViOyc2+do9/lX736v/PvOVMdRDLp2pC/9TeqDIOVq3aDH5dAUBRud33sG0js3lKohiyEdoSV59H4TL4gPY+HP2FpW/0rXO5LV9/K8cY6YHtgyZObe9sYPJEQWmWLfUfz4OgkWOWmShelYsNClH0FTponWG1I8uvClUIZkRHA+Vsfp9WvmAwpzj0vUlPctGtEuHu3e3PSHFh+ddKmAtwiSUo7LdGWuH22HGGa+MztXPpqRvb97WOOOhmOJ4BElvwZ04g==
Received: from DS7PR03CA0171.namprd03.prod.outlook.com (2603:10b6:5:3b2::26)
 by SA1PR12MB8094.namprd12.prod.outlook.com (2603:10b6:806:336::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 01:01:36 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::d6) by DS7PR03CA0171.outlook.office365.com
 (2603:10b6:5:3b2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Wed, 15 Mar 2023 01:01:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.11 via Frontend Transport; Wed, 15 Mar 2023 01:01:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 18:01:26 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 14 Mar
 2023 18:01:25 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Tue, 14 Mar 2023 18:01:24 -0700
Date:   Tue, 14 Mar 2023 18:01:23 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        <kevin.tian@intel.com>
CC:     <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <robin.murphy@arm.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <chao.p.peng@linux.intel.com>,
        <yi.y.sun@linux.intel.com>, <peterx@redhat.com>,
        <jasowang@redhat.com>, <shameerali.kolothum.thodi@huawei.com>,
        <lulu@redhat.com>, <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBEY49XtiFUImfe4@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBAuXo166M+z8b3z@Asurada-Nvidia>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT039:EE_|SA1PR12MB8094:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d6557a-2dec-4e82-348b-08db24f0d3a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4vF6nyOvvD/g6YT7tPZnUwWdid/IcOG9dyuNcdWQoPOfAQTsEQkTcnkoybNellDONfkBYotYfyVYf17hKs7iGxffOAL7qAaSbZwyYZ91lmd0aXAffv19ihC3XldVN7Psp3pXFpaJCIeUTKG3AhHZLkbC8ExHjSJuvDP3IjIPwws6/eDIJwhjhl4IPvSUmH8eppySr6Sy7vrVEK/L2tVphYnrs3HRvcDzN8tNgTbTh0eqv8d6fUGm52mifJ2SLVMECq5cDXbaOxPlcGrp7GIExnwPMiemLASy/hritx/NnigrHSrOrTuM7QncJEcOX5NH/6mNDUq00qb1MsruZCZ9W/Av2RsRRvcLGzm3wPc0fkwlw7ZmbOwI2lCLsbSmMz5wIjUmIRfyCmlncosZlunRz/ZIKGHcazypAurkJRSmV8B6z4njkJDYCpGrX+2hbEbivxlpeU6zbcHeE9hScgVV2oO1uXzsFuzE0UzicDCu3HmGAqqJpQBuiQt8Rn9IaYK07vL0JC0qYpIk9WswX+QzPWFxU+hHoCA2vKTbY3140Kh/hAiShONfkPXXdPWAOGSuV57mChlwUfoN72rNFO5gqF0LHmPOxaPkM1pI4crzgsOZxzzTFeJb0ZdRjO3WCOUXFqjoYZMpkV6uaEDFEFTIheAn5b3Kio62uocR0VcD++Dz3q3j5/Jj5GB70okhvcuH9zlFkyuHViqr3MvsNa2yKS1L2NNqiub87WpiTnoYesTt9rY5D2qVEYjxg22e6VJI
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(336012)(8936002)(478600001)(4326008)(54906003)(110136005)(70586007)(70206006)(7416002)(8676002)(316002)(41300700001)(2906002)(5660300002)(356005)(40460700003)(86362001)(7636003)(26005)(40480700001)(55016003)(82740400003)(426003)(9686003)(47076005)(186003)(33716001)(82310400005)(36860700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 01:01:36.2893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d6557a-2dec-4e82-348b-08db24f0d3a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8094
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason/Kevin,

On Tue, Mar 14, 2023 at 01:20:52AM -0700, Nicolin Chen wrote:
> On Fri, Mar 10, 2023 at 01:36:22PM -0400, Jason Gunthorpe wrote:
> > On Wed, Mar 08, 2023 at 05:13:36AM -0800, Yi Liu wrote:
> > 
> > > +int iommufd_access_set_ioas(struct iommufd_access *access, u32 ioas_id)
> > > +{
> > > +	struct iommufd_ioas *new_ioas = NULL, *cur_ioas;
> > > +	struct iommufd_ctx *ictx = access->ictx;
> > > +	struct iommufd_object *obj;
> > > +	int rc = 0;
> > > +
> > > +	if (ioas_id) {
> > > +		obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> > > +		if (IS_ERR(obj))
> > > +			return PTR_ERR(obj);
> > > +		new_ioas = container_of(obj, struct iommufd_ioas, obj);
> > > +	}
> > > +
> > > +	mutex_lock(&access->ioas_lock);
> > > +	cur_ioas = access->ioas;
> > > +	if (cur_ioas == new_ioas)
> > > +		goto out_unlock;
> > > +
> > > +	if (new_ioas) {
> > > +		rc = iopt_add_access(&new_ioas->iopt, access);
> > > +		if (rc)
> > > +			goto out_unlock;
> > > +		iommufd_ref_to_users(obj);
> > > +	}
> > > +
> > > +	if (cur_ioas) {
> > > +		iopt_remove_access(&cur_ioas->iopt, access);
> > > +		refcount_dec(&cur_ioas->obj.users);
> > > +	}
> > 
> > This should match the physical side with an add/remove/replace
> > API. Especially since remove is implicit in destroy this series only
> > needs the add API
> 
> I assume that the API would be iommufd_access_attach,
> iommufd_access_detach, and iommufd_access_replace(). And there
> might be an iommufd_access_change_pt(access, pt, bool replace)?
> 
> > And the locking shouldn't come in another patch that brings the
> > replace/remove since with just split add we don't need it.
> 
> Hmm. The iommufd_access_detach would be needed in the following
> cdev series, while the iommufd_access_replace would be need in
> my replace series. So, that would make the API be divided into
> three series.
> 
> Perhaps we can have iommufd_access_attach/detach in this series
> along with a vfio_iommufd_emulated_detach_ioas, and the locking
> will come with another patch in replace series?

I recall that we previously concluded that the unbind() is safe
to go without doing access->ops->unmap, because close_device()
would be called prior to the unbind().

But, to add the vfio_iommufd_emulated_detach_ioas() in the cdev
series, we'd need the access->ops->unmap call, and the locking
and "ioas_unpin" too in the detach and attach APIs, right?

I tried a bit of some update, across this series, cdev series,
and the replace series. Though we might be able to simplify a
bit of this patch/series, yet it doesn't seem to simplify the
changes overall, particularly in the following cdev series for
having an unmap() call and the locking.

Then the replace API would mostly overlap with the attach API,
by only having an additional detach(), which means actually we
only need an iommufd_access_attach API to cover both cases...

Can you please take a look at the final access APIs that I've
attached at the end of the email for things mentioned above?
Hopefully we can confirm and put them correctly into the next
version of the three series.

Thanks
Nic

-----------------------------------------------------------------------
static void __iommufd_access_detach(struct iommufd_access *access)
{
	struct iommufd_ioas *cur_ioas = access->ioas;

	lockdep_assert_held(&access->ioas_lock);
	/*
	 * Set ioas to NULL to block any further iommufd_access_pin_pages().
	 * iommufd_access_unpin_pages() can continue using access->ioas_unpin.
	 */
	access->ioas = NULL;

	if (access->ops->unmap) {
		mutex_unlock(&access->ioas_lock);
		access->ops->unmap(access->data, 0, ULONG_MAX);
		mutex_lock(&access->ioas_lock);
	}
	iopt_remove_access(&cur_ioas->iopt, access);
	refcount_dec(&cur_ioas->obj.users);
}

static int iommufd_access_change_pt(struct iommufd_access *access, u32 ioas_id)
{
	struct iommufd_ioas *new_ioas, *cur_ioas;
	struct iommufd_object *obj;
	int rc = 0;

	obj = iommufd_get_object(access->ictx, ioas_id, IOMMUFD_OBJ_IOAS);
	if (IS_ERR(obj))
		return PTR_ERR(obj);
	new_ioas = container_of(obj, struct iommufd_ioas, obj);

	mutex_lock(&access->ioas_lock);
	cur_ioas = access->ioas;
	if (cur_ioas == new_ioas)
		goto out_unlock;

	rc = iopt_add_access(&new_ioas->iopt, access);
	if (rc)
		goto out_unlock;
	iommufd_ref_to_users(obj);

	if (cur_ioas)
		__iommufd_access_detach(access);
	access->ioas_unpin = new_ioas;
	access->ioas = new_ioas;
	mutex_unlock(&access->ioas_lock);
	return 0;

out_unlock:
	mutex_unlock(&access->ioas_lock);
	iommufd_put_object(obj);
	return rc;
}

int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
{
	return iommufd_access_change_pt(access, ioas_id);
}
EXPORT_SYMBOL_NS_GPL(iommufd_access_attach, IOMMUFD);

/* Identical to iommufd_access_attach now... */
int iommufd_access_replace(struct iommufd_access *access, u32 ioas_id)
{
	return iommufd_access_change_pt(access, ioas_id);
}
EXPORT_SYMBOL_NS_GPL(iommufd_access_replace, IOMMUFD);

void iommufd_access_detach(struct iommufd_access *access)
{
	mutex_lock(&access->ioas_lock);
	if (WARN_ON(!access->ioas))
		goto out;
	__iommufd_access_detach(access);
out:
	access->ioas_unpin = NULL;
	mutex_unlock(&access->ioas_lock);
}
EXPORT_SYMBOL_NS_GPL(iommufd_access_detach, IOMMUFD);
