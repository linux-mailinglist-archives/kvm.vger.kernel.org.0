Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2596D12EB
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjC3XS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjC3XSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:18:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068710417;
        Thu, 30 Mar 2023 16:18:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0isPgs8DAGQxZ2RSrLqRNoQMmwgERmJEjjXE67Xwuehc7caYjRfnqJRwkXpOJGXkhdBpdCl+spCOSkqrjvolz8UgXNNihAmwNG0qLfeCUBXoprXq1JjmNWll0ipL8lpWMRk3x7p5OE4W4XE4jBjaqUKrYV6ziyAsLuaS7KExIUNbI3YIn5pL1imle9ektviVaCsXUEAFH21OiFsTbUA/7faqdvaJxUdsrzGbGpM8L+rSdDy6RBGBEEzluxXnZNpdjZI4IkR4l/LZ7voQIDfymXYa1UHvHYpepfkS+F1CcdYHoBbPuu+7grx5QWppmsPrVNFp/EDcThkBovfgKaO2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26UpzFiBQkjtCehSyj97lEqxDrhS+wCgTYK70lFeIcw=;
 b=gTMTZghjID1qfucDlx7spUNZJMyOR+YmvmCmrC2G2Qxz6IRJeXKQvfg19IhIzMOtixDJRU6asDtsjdpdi48m6YBuDHthBGW7ELsdj6G+PhDUGuQpnDTbfRlKM/V9X/70MnGJ4Jysx6+pYWsneMSyxQAcu+82uGtA2MNh1WdgefDbkXB/bfW5RMQrQgVcnHrcGYKrZDhzbcst0MMJ3BCarnZsRL7I591BjKqV6ASz3bu5mlH40rKmahxYMMMh0hBnr8PYodQemvGIEw1FGBOChRShLfEIQBvkF4F63AbxMK1ctsfVbhogvCU6EeWagOM/2ERqW4mLw21uMemfIEQAZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26UpzFiBQkjtCehSyj97lEqxDrhS+wCgTYK70lFeIcw=;
 b=R8T8H/skWk+G5I4Z4v6wWwtvzSUP/JKldrvSwxC1YQWuO0B9Nl0vbMB4ijzH1rd9dNUoThIw1Jv7nSSWH0kEKvzYrliSB546tLN6j0GVEoxaY6rNr3eALLPXuC26IsgCIYH9sJwYuCFpw5WtJBjTporXCZrusGRylpqOQvYsK0bmT0XBtlpugW5g2kRa6VOi2EGkyUsfF80fFPa9xAtrDZoaxWvbcK2GHW9mICPmHKD3TGQDlOR+yVSZ1lxCKYGTM2yV5raCDG8IgolOmPQM5CejfA1MFmAo9JTT2//G82UUpffeyarwY/IQ8PargIICgS5Lbnc9Gx+FmIE+ccrQlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:18:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:18:20 +0000
Date:   Thu, 30 Mar 2023 20:18:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCYYu2jPdczuzaFE@nvidia.com>
References: <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230329094944.50abde4e.alex.williamson@redhat.com>
 <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZCYQ5zhmjg/xQmTZ@nvidia.com>
 <20230330170531.3b66c05a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330170531.3b66c05a.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:208:32d::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 97911a7f-91b4-4d60-ece2-08db31750d41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4yIwK11YVxrkvsFNUikA2sGrBuwXtlvlQCAlyWExAv2QkCgPu3Q6QKBK8PQkzL66PhMX/HzipsSk8ASNhCslYHW4qvnRkWlZquJ9RygoUptQq1KKE2v9RelqSy7syrHcKeYfYq7NnKIWOSyV+Ix2v5KFDagoDwrlXMLvc+pVde2xBbYWy38PDEcapkCgCyDoaDSyBL4NalRvcxibWk6nE/Wtb5QzCZLUqKdRtTZjzm/YhYgigANIB2RTr7dDhYSXDrei/LrANU21Tty8H2ymdewb3k2f/YBsJfGzkc2T7dHJrEHMmBo0JeWgCE3tfnvg4XHlb89FrGtzCYEyyQ92bHvnWTxYxLAPPm1n7wGmxAhyFI/Lof1rmY7aYPkqPV1ZkyROPrUr/QiHZaUBmNGpXGloXomfrykrhNYL84eXrTEDLNp9Jb4gn0UOd9+Lmi5CKmd8Dzsp6Ut2/+FNF2UCJk/zTUCGxn/pVCUViRPxquYCOPQ0+9SdGk6ILZjhIuyEzQeejG/LRJhuFnDpZws7BPEPUBN82/Se6y1plcvtHyF1HEkAKLmBVDwbQ1UWM0r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199021)(4326008)(8676002)(6916009)(83380400001)(66946007)(66556008)(66476007)(7416002)(5660300002)(38100700002)(2616005)(41300700001)(8936002)(6486002)(316002)(36756003)(186003)(478600001)(54906003)(6512007)(6506007)(26005)(2906002)(86362001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1JLzf3XRmP9F2jm/SAzKK21y+41XDUt6RJkBoUU9Y2y09HF5fOd3Z+Gpna5?=
 =?us-ascii?Q?roHXAj1i3cYO7iHo0JFcvJSzl0hXxzkKhBHZF22FDH8EI8pp6zGramYIe7DF?=
 =?us-ascii?Q?ByEgV+iMjIDG3IH5bQD71uZIucs1/KrdyRZgtUqQ/SMIcL7RTheglV+umBW+?=
 =?us-ascii?Q?/c2PZg3tif4PiS7jRKhbhwTumXl+ChZFvC7EgNeDYOzAlpD3KIwtNBRoBPRr?=
 =?us-ascii?Q?TLfyuAWKhD2LLWy5xPdzZojtuRwEPoxJfYNxU9r60h57H8K2vrGgSRBPUE9P?=
 =?us-ascii?Q?95D0mwKsV4z+5xG/o12BPKpQ5N0/anTHOnsGGDG2PHzh6SNjx/AMk76LhszA?=
 =?us-ascii?Q?jYZQgM+/7IO1edQ+dGpSFlkjN+2ul3LqitmtwMYy/9ShGeSKRSylGFvzA1Sx?=
 =?us-ascii?Q?08TXeQU9uLHiccDQwqNWGsqAckzfFnAsIb0BjdJoodJE/RDGzGQzOFPURU2N?=
 =?us-ascii?Q?+hoP4zNAoDqzyzqm2N3t9IBWS5rbeIhQqSjxezZmTn+wBrPJeiD78boTx8Hd?=
 =?us-ascii?Q?4Lwwo348fjpyuxhZIZZffs0VTZOCY2lyzQXhEbGAFSSeQ/c5dRDuMfMAXMxH?=
 =?us-ascii?Q?5owLf7JnF1X1xdyuk0G9ROhu2HD2kNyRS/49Yu3CSmlUtAyTw6L3jvm+pdtH?=
 =?us-ascii?Q?Zlpuwnf0zUg4gEIY1qRDMWeQLzk8zoGgSSuCnrH+I/2jXOaGYCzqiLfsE0Lw?=
 =?us-ascii?Q?PIlj0c9AEvZTfWyHoNJboyFtT+Y+bmmmppgJLzzb3qCUifNJscXuHP+Xlqro?=
 =?us-ascii?Q?OeaO497aLzOt7bLlBZVfn+HK1DqM+F4gEVykYzMGQ/44aOGmvzEOGZfleZjo?=
 =?us-ascii?Q?UYfBfTO+akcifUP3EEbDh4P+4luGQm4glhSKtnCMVCzhirHTZf/pT6hscu4Y?=
 =?us-ascii?Q?UwmZKmNndvgXyxHnnK65IR2nq7Rg3tAOIFGkviFlh4Lq/s/dNt81lX5LjdDO?=
 =?us-ascii?Q?JGunqJpJsJw6odBzoKYwoIEtKCdHoSdphf00OecDy6BPDcSigC8cDbNNaDDv?=
 =?us-ascii?Q?FQ2Ar/y1pThLd+N9mShfTHLPdUs46utFuxWVfeRZtZebFykdPIrSeJg/Qp6H?=
 =?us-ascii?Q?eNv81cuc9thV2lF+r12JVaMyxoJX5PLe4z45dt6q612TT52J104IIhQZHlF5?=
 =?us-ascii?Q?ZJXhsXvIJ+UaSyj4Jsn47buPtLh2ry/hTJAckwZmiemKQf78m7Ru+h2GkSsT?=
 =?us-ascii?Q?RCQgAWmjHrsVdopnJoViWQ7/2Vpo8OzAMUWup1N2+KWQQfCwhQ0B00HFxoWw?=
 =?us-ascii?Q?cVBVbjUm/5iQRxLuuqkVp1N68XBMepKtK6uRkx6a2nmm87QcK60ffwyRETiZ?=
 =?us-ascii?Q?3ocAhXwo7/4tCF9GynD2cZELf2mgNGBkUTsI74rNU95b9AnNkESbW9r12l/O?=
 =?us-ascii?Q?8o+w/8hSeHi3MoHla+jxxD6H2ORYtCfx9e7LaS+y6JzIg6lm+k/0Le+MQsb2?=
 =?us-ascii?Q?R0oAe/NwghkvuxXY/pckAfJ8r+SCYHBGvXDvuXznBPa3SohITgZSwQECwfJT?=
 =?us-ascii?Q?+oy3ZkvUqOATauENZbirW7dIHKYGFJXpw75AAHjKYwoxrCypuQDYDFtNTt1R?=
 =?us-ascii?Q?Mq1Po1ARtu+JOQCQmnSlClEMZhZaa3X8/SKeK6lx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97911a7f-91b4-4d60-ece2-08db31750d41
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:18:20.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okKlZj9v33W+1BH7FjSpQhzLkZYZ+a7MgA/NcCJ+LTQ4VgVZey06IAzB9hzXtX1L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 05:05:31PM -0600, Alex Williamson wrote:
> > I suggest to check for VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID on input
> > as well. I know the old kernels don't enforce this but at least we
> > could start enforcing it going forward so that the group path would
> > reject it to catch userspace bugs.
> > 
> > May as well fix it up to fully validate the flags
> 
> Is this under the guise of "if nobody complains it's ok, otherwise
> revert" plan? 

Yah, assuming people don't pass in uninited structs.

Jason
