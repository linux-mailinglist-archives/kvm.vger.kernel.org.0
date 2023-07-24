Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2057A75FEFB
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 20:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjGXSZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 14:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjGXSY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 14:24:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1C610DE;
        Mon, 24 Jul 2023 11:24:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lea8tJcr+cHZCGyXznNMLZyS5FBQSulJpPciSWub+6/4zYp7cvKskiFc8HEkvdJ8aUrfclkQHE5jHwQorLbB4fr4klUMtcBORnR7MJAEVoOVmeIkvs680sEC9KtkPHDq1vuku+98lU3LDlIgk1kd01uRSmd1uzbLVyqjiNdeRq1GRPvT96Y0j1OE3duHwI10j13BsWNvHOrskWrfviyohdpJTReyxy/R2dy93c48DKVJ7iPtJlYjfpSAIcOC85opDjWWSwIt0Hxbr7xfdYWXOenye62yVi59Z7ENM1pD8bLts5fH4B8fAHAb+m2HKc4ff3sY1WWCHAMLV6o/xxd9Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPBTRxMP2s06jVcxBUjq5l7Biz8dwHogEA9ExtkRWco=;
 b=XaqaqfbOQtTuX8aASNY8vq+BV0dd379VKrnhP8LOvQGIdo4+ipirUDqL0Fj7rn2aofjtLzJ7b+4BpuVPEyOAEAh/oXq9oRpmqwq1MlUXdes6WaH7zJICU4y6DWc8rwvtC0k2jC84E8tPYc239125iflfaFZD74edHkZqeZV15XRvDJaTl+qJvNXjWlKJVXKwkypqEWe4kPAsHzbZJq2exxuZNEAw/WBP/+1XI6lxR2dpm/UDkX9ih+Q0LUOCBqCeTVGyqsGvHL0cM0Qzm6abyvb5e+t1oLz5xX0yTGxSZJKHw/MR1e12KDfLPb1mUflLqGEIBsI+oaeUfJ7whN6Dvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPBTRxMP2s06jVcxBUjq5l7Biz8dwHogEA9ExtkRWco=;
 b=L48eJIxaznU0e4KHjY4i/WsPSdyMjlKHjnHbWXvfhGRZnzwSo7y4TUDJtYQAVh8wmbvkxuffJd6EjlEj0J7xSvUljdvrFXWW9KtAE91PAfIdfZftL4YSt7yNL7rZe/7obG66famZ1jn+j8kdx8TFL55jeQk+E5d8rzHvHqKZXCm0S9kEB1OpBIxdGO2gasj7PHTNJyVQNgJUOOo2ZANWQHuCdzh301Ir+qypzDFdeVLKWX7nayqlxqEYLD+G6xnF03pLDiefd7WSq+XO3nA5jP9IsCqfF1ayCgrV7qpyONGcYWm/wr5AkOZF2rMdD2MS7GZ6qAh0nms9O9zNcoaXYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7111.namprd12.prod.outlook.com (2603:10b6:510:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Mon, 24 Jul
 2023 18:24:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 18:24:53 +0000
Date:   Mon, 24 Jul 2023 15:24:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <ZL7B85GfKxVWK6ct@nvidia.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-4-brett.creeley@amd.com>
 <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ea5cd85a-e29e-d178-5b17-1440be84f5fe@amd.com>
 <ZL516RPMMHS4Ds1k@nvidia.com>
 <fff62e3d-997a-69fc-fb2c-43ef9e7def30@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fff62e3d-997a-69fc-fb2c-43ef9e7def30@amd.com>
X-ClientProxiedBy: BL1PR13CA0351.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7111:EE_
X-MS-Office365-Filtering-Correlation-Id: 42527408-d297-4557-7f2b-08db8c734621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLztejbOUklxQlJv3RQ/LIKq2bWMN76dvre+BFWeL9ELY7TG5pweN08gucg3kAnHK8hvGSZltriWRXga5OX5LCRaOLb7gpvIxkJtO3wVc09CHM6Fu1G3WjUS57l44hq9bG1Bp6CCKCdpNESd5MefA/zV5RrhbkDplyYkdNcLUJ/+wRxydeNVoJgiSsy59rALswZhzeByP0phXacRLF9Qmn1Kn1PvFhS8FM6nwg5xw3eYhMa5/cexJ43HINTepNlAo9oNVYZsdKS70zgiyM9RRMfGqEg1sUkYchqe7W65Fk6jFhKm7fawaAtWzZ6RGDq5/mrBRpbrNmWUc4GsupBRPvBEsSWww43a7O6z/FNd6Xbp1UJKPbEaUQ+6bPheBmr02vLuHGDISQoxx4MQqxo3whdvPxoNcrFtSreoZgorEv8+KJHO37KvD2tZBxGmT4iG3kpkXR33oBwBjKPEs0tIgIsB94TC18BJgymXrMB+cgjrk1IbmWC8V3f4peCCN3jfVC9rlF0rwDoCc8LDpVbLN+niFHmvnP91fNgSAz64KuftvAvbO5HggfX5JEAk8L0b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(86362001)(38100700002)(316002)(66556008)(66946007)(66476007)(54906003)(41300700001)(4326008)(478600001)(8936002)(5660300002)(8676002)(6486002)(6512007)(2906002)(186003)(26005)(6506007)(83380400001)(36756003)(53546011)(6916009)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bLwWsg4ZiLrdSUwVoCIoNba3OtGJHliAg5wxtTHYFU1EE5k1kmawSWuadxCr?=
 =?us-ascii?Q?gH8RyrVYbeaiQiJpR10nks/KF31i0B7gXUg1ZNvGfLfAi2L1sa9zr26Juj6h?=
 =?us-ascii?Q?oqdMs03Kqa9H+RFBP3nIUYk3XHxTmXj5HQmVnk09eLtp+7kuzPvZZjrhknqN?=
 =?us-ascii?Q?5hASNTm1Se+/WceN8wO+F6Ri7SDTspSE5ZEnVmzB5AwCG3rQcs+NXkdBSKCy?=
 =?us-ascii?Q?FATSANQDatZEBnfd8gCN7e1O3tVCp0+TEKYfcsWtksZPvBMWufGrC4p7WldM?=
 =?us-ascii?Q?aYwP92MGOmEL04Fhf7onkh2JLISGYkVIa9bcBD1Gr7SMTC4IHnqetuakINhp?=
 =?us-ascii?Q?jAt6D8LdBOXd/SfKKAxsNDWmWiMFwljMPrNRmoTCyfcmOdDMmIOJliAkgcxk?=
 =?us-ascii?Q?M5FKPsGRf5X9JJAewYkpH16gvrXYeLrDfMLjFOOsi+XE0FhWLr0rynoTH1bg?=
 =?us-ascii?Q?AOnEVqNVzC+/QV6qm1geAraFIZqhrLLG6A/2vIl63oEEDGty151OobBZezm+?=
 =?us-ascii?Q?DBs0OaFNLBLJaUgelJYej0rsmA5Nhmm0dWYR81CLzajS7bDtAipI9yePI1s6?=
 =?us-ascii?Q?sYyIzqibZQ55rIbT1uMhoX9/L5V+TMprMP1QRkRP8FvkjnB/nISXK+OAmyxS?=
 =?us-ascii?Q?+Ye+BwbcXz/eEnfoPXkmsTNOOkEP0SDrZo1J45Upn/nLSG2Y5Xi/GwQmiHAU?=
 =?us-ascii?Q?jmPaN+LykGMQm1QZvJQl611fVuHEv0XxwWFGKgajhx3KFrdJdhQrd6vvzspc?=
 =?us-ascii?Q?xZ1bzf2OY37w/ZeEUfe766i1CzhEDzxhEjH9f/3LPfntpJlhNaEx3phXKMCO?=
 =?us-ascii?Q?JxP2YQMOHXi+hOS0SRj2OWnuk+i2spCe56duD91vLKXICMQfYfLif7sW3vC8?=
 =?us-ascii?Q?Kgf5DStED3hmAXbkN7aYJjtZ034rcbFbBXFiQcomHHlXbUo96wKFu/0Jrs+R?=
 =?us-ascii?Q?lq6DvRVwmvtFJnFG27vxDf/oV04Ibw76NNECjCZzIsfJ35KN//vVWtp7BstO?=
 =?us-ascii?Q?JAP65cgnTMs6n3rwctQhdCavfJGQoJbSXOW9PUIMuKFv8zfPKF5Mx+GXksTz?=
 =?us-ascii?Q?SfqnqICSKsnMPH5YoFaidjTD1dp1ecu/cQtPKq8Igl5TvUXl+0UJMsBnfMK/?=
 =?us-ascii?Q?uYYpVDsURu8tnxpIKbDxdAoFe2Zt9YT/P/f5ne37dv4eclUNRU52VDhYEg+1?=
 =?us-ascii?Q?oqYgzgajDV2Iw7dNhSbjLKyo1W4uG5tASoamF3LKkJd1167cByPdfrGMKfvU?=
 =?us-ascii?Q?/8ZTewP0byTP+qYdR4Cj20E3/miF75PKqN6Ca4v0GJ6GZPizO6dLgOSCbT1A?=
 =?us-ascii?Q?EZXZwjx3kShqxGFfubHuLjXl/4d8r14Ae39KocE8iirQG/BPs9PrfAurkxYV?=
 =?us-ascii?Q?UBFtJPzPOX73fPkECB/Vnp7ZMeSQ79LnENUWQv0ivlqaeEZMcTwc7uO0VjpN?=
 =?us-ascii?Q?2HAedJA0XaFSNr3/bjI1UPiYBhVjbiuXgYrlPsR+F7lDYp3hx4aoevQawecY?=
 =?us-ascii?Q?MTtGIlmyiiQ8lYOzdGO4dMP1znzSAJ40NPsuqby+GIEgXcEKKuFkh313tOy8?=
 =?us-ascii?Q?PWKOmm3IfKJTukt+NTshDl7+JaciDTkDXfSlwtfW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42527408-d297-4557-7f2b-08db8c734621
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 18:24:53.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCIQtXaMRzaghzpzDxV4uf/PYbW2TTsa5ZHvgePaPj5Lky/DGJrs/W+jw6RI5N9o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023 at 11:20:42AM -0700, Brett Creeley wrote:
> On 7/24/2023 6:00 AM, Jason Gunthorpe wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Sat, Jul 22, 2023 at 12:09:58AM -0700, Brett Creeley wrote:
> > > On 7/21/2023 2:01 AM, Tian, Kevin wrote:
> > > > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > > > 
> > > > 
> > > > > From: Brett Creeley <brett.creeley@amd.com>
> > > > > Sent: Thursday, July 20, 2023 6:35 AM
> > > > > 
> > > > > +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> > > > > +{
> > > > > +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
> > > > > +     int err;
> > > > > +
> > > > > +     err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
> > > > > +     if (err)
> > > > > +             dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
> > > > > +                     ERR_PTR(err));
> > > > 
> > > > Why using ERR_PTR() here? it looks a common pattern used cross
> > > > this series.
> > > 
> > > Yes, this is intentional. This is more readable than just printing out the
> > > error value.
> > 
> > That seems like a hack, it would be nicer if printk could format
> > errnos natively
> 
> This is already being used all over the driver hierarchy.

That seems like an overstatement. The 100 places it is already used
would all be better as some '%de' instead.

Jason
