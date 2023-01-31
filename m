Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A67683A78
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 00:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjAaXa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 18:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjAaXa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 18:30:58 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC26900B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 15:30:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=io4JXjMBBaIIZ5N/EA4rRqrpMMxD04NvinjIhc5yTpTCDJaRJMDBliTN4aaSyZUBk7QqnmeRSK1ctpgd45sajhydmvYuWRYSFY8hawk6hYoz4NrZf+6MIBXcyMHOeNk2p+jqCUFrP628vOdahq/take9c/gpwDhna5FAKFIud6xspaotfOi+fgpKR726+JQ9hWgJn27qOLGgizyXxLJICt8JnQwLHhjiAkh5ZI5B+27mqJelM9/uDJ9NlIj6LMv41Go5GCA9gnsmCgN6D/axZEstLGs3+ev1xsGc3wqhfzamYJVGDwo9c+J4rDxqzPUHuVSmOwYlXu2HBmVpCAiE4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JH8gBaG2eBZ+RULA2nc+Dmn4CgxPGNdA/oHHWjwZ3vk=;
 b=RAnH3boQ7xBw22Bn24dSP2L2sIKb2UuZ90I8sQ3TUnCjrlSwMWkigTQb5LKvEaNc2ibOx6XF6nOOHnO/pl7SrhRbt2s7kKXVtt9o68fikpXqmuKRFcCffqvP1wonk9oAuvmge9rfwE1b6GxjbYkz3r+p6yq7vxhJurjMpFJRocq3ICFfd5yO7j6SPooZyxaWEKvXOL3TM+ns7treBWvwWAch3aO7v9V2DSINFm8Hw7CAajoxh90qqeHCRh5eQjurgV1cIQHmLivSetnYwhtEyztGA1spstun3t1ubUqGjrUo2Q2Ff3NDQktk8DUjrfDvsrfycShqOdMJdud+X/NF2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH8gBaG2eBZ+RULA2nc+Dmn4CgxPGNdA/oHHWjwZ3vk=;
 b=M5eX8ukQoxYlH6mRZ/pE7cziRArlr9NQb3AMe7wEZkffgXY0AAgOptq/0F88nPi9ILwow401+1saE42xzIjo3uLSQxRI/DsTCekLkVSuDUG1VpFkPGDPhQk7HGt39eizVoUc3KGpv5CBdPcopbksov/YRCCE1W8xnZg2sXJGQua81JNnKg/F5Gw3vxZ5twDkzVmYq1Bpm1EDXafolOsjrD4+wGaC0CZbJy0eOzpuJXnUXEgoVX1zjnmiE9nBNMjbdVnUdgYT2c95wGES+X7IcnhEelBygaTlfWX8acF23NCHlAeHuoEk+DdygPkynqDp/vlvB4lg65vHgkOWZiARCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7499.namprd12.prod.outlook.com (2603:10b6:610:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 23:30:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 23:30:55 +0000
Date:   Tue, 31 Jan 2023 19:30:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        alex.williamson@redhat.com, clg@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [RFC v3 16/18] vfio/iommufd: Implement the iommufd backend
Message-ID: <Y9mkriFLL43OGbHq@nvidia.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-17-eric.auger@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131205305.2726330-17-eric.auger@redhat.com>
X-ClientProxiedBy: MN2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: f1a4a8e1-d192-4347-f0e2-08db03e3333d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ygj4c0HsFonTN0jiGLXU6UlEP9a69mo/NXEOV4NnLUuv5LPM5wI5Kk7nDATmVHwunf2UobBHQH2x60aCw064Z1ptOigdNYX18sQNXieC922YYB5PmYFfi8b7gVaYN55AX8Fu/1n6+UHWEz+JM4GZU0x50BLxH3yZ8fFpiATIFDFhdQ46ULvwOTKm5R1xzN4Iw1lPX+xQZcFTr2QzuvTaulBIpVTuTRz+lLhk2tXznTX01tz3N+0ErKS7QdX4JqT7ivUVNVbs0uqoseEDTWfgktfXTVHclcclp6hirVjum2de6MqrmIYSFogHdkns/ETJN8N79MuPtHVPdHe/KyzAssJo883uMx3doYDLV4vQSA+5zjE3OYZvqhBVefgCq037chP2Zi01jdgJyK7vDdYzLBeSiycEFpS1E6Eg4DZSkys1wL5zfD4tCrV419ioAFAr0KoQv5bcJhdGcsdYN9vOhjDWP3m8ElcARGrXmcmQKXzV7FGpe2kCFy9/Xbt/IRHlcIcVomnuu0rzXrvt8a4Je6W6rdu0MgdEyLQ6cImtf3nwJqc+1DXhiJqDLI38Ty+8ZmMab8QztycASD17v9AcsY4RCVYr2gKdtc3vPnhCCRbx5SrthxVQGeTdf5yo8vycmWwxwikvDDKI1Q+FphMiXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199018)(38100700002)(86362001)(36756003)(6916009)(41300700001)(5660300002)(316002)(8676002)(66946007)(7416002)(66556008)(8936002)(4326008)(66476007)(2906002)(4744005)(2616005)(6486002)(478600001)(6512007)(186003)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OzI8oFLIeKwKURsQTUpobhvVYg7kezoqCNUt0L/64rDtshXaqQpranVeARnn?=
 =?us-ascii?Q?mzlG/ZogF8AWs6E5EK/FZH+JCGzJ/Pu2JrrGrhMLACwMdbu44OYW4LWAlRKv?=
 =?us-ascii?Q?mKkef2Rx/Pmzmr3JaKOGI5FfEPlDZFVgrx/P2R4LQWMoJlApgHsbkKYiF1R2?=
 =?us-ascii?Q?HblsvIK2zkyRukLIQXHoLBbjkys/6w+hI7rxbr16B0ejcoBKO0loTMx8I9gs?=
 =?us-ascii?Q?ZPqFUzld+Lm+6FaPiaVVcGNZvbBY6iWFIh7SF8jJywd321QYFD82aWWdXVuF?=
 =?us-ascii?Q?RDqhFg1AN3ifCSSm9o6ZMLMLkR4lhMlQ1PWuR1HM554mxYvSa/SnWTkPxL13?=
 =?us-ascii?Q?g/lBRd7+Smk1NMSHBrKOJvw0UFmPZo5emYoDQDq1Bw+phaogQCn6RT4P9kPb?=
 =?us-ascii?Q?/IX154wAzPUS3iGtS1quqQeX5GWmj6aXsU98JxxzSCfNYXrjwp/iJXCptbN5?=
 =?us-ascii?Q?2EELnuFB1rYAESLdbfjdyNn3nDS+uMoPDPn9YpGGf4GgyzxYW/1ErGMLN3aF?=
 =?us-ascii?Q?K5nwdsEoUNvbU+Huw++dD6QW6nXtpgV80/yK/83oV1P9xjE+YJc+QFENYTMI?=
 =?us-ascii?Q?2IjAT6ZRMw7ceAWmjQKavChY1Bv2Pmg9h9fdClgsAcvW/FQqs25+9LqPZvfz?=
 =?us-ascii?Q?Ro0IuALfEnBn+W05alkJ3TJ/ijbb/AuZVS9NE2mcXYrcrzkpJT3O3pRT39su?=
 =?us-ascii?Q?iPJhPG9dARCRLibbd8tYi8LwAPrqRaA7IHNhVVwN+dKKw1VGlykmLQSsj3r2?=
 =?us-ascii?Q?OV8w+fJDG5jMrWVtaUACyIubnSSj9CU/LJsE6fUwNIRTAvj2f8ycSg7u7fKy?=
 =?us-ascii?Q?l3VY/9brT27yEgJaGvSCzxQ3HUcJeAFpCgsn9Q5LX6EA7IssVR5zA1sKdED7?=
 =?us-ascii?Q?agpm1A9InSpUh61ULtN/cAv4wV+OSKs4iLPftQpM075Fq8Uo4D07sQUIj8T/?=
 =?us-ascii?Q?SsiA1dw67Q15gL6WbARHst17nuqZtOv2qm4YKlloWfp+6arOm1Q8ntFAc3FY?=
 =?us-ascii?Q?5I3RkFQ6+OMwpN1TPAEx4dK/j9UbQy47+TKnVH2v0LkCJGio/BfvzHKvv10x?=
 =?us-ascii?Q?L4JF+3rKNulASihLGDsdSizPkE2gmquJbrXrcK3FXW871eKDdMl5MFhZsBMr?=
 =?us-ascii?Q?8Elrw5w+AwHmA0b9rLQKHROAMRVmU5zInK/lxeBlN86agmVVqNcUMx3gf4Wn?=
 =?us-ascii?Q?xBErg5/Or2xmXMWWS0t8bOHRvaMBUoY05i+/+fyd/mPTII477b6UpD+e34In?=
 =?us-ascii?Q?ikFr3BdPePI13G9BwhPruxQO0DQmQTiDybRoWbkTX+2oN+rNSrQe4ZKpHMn8?=
 =?us-ascii?Q?g6Y9vSf2brhpfgUEsNgIj+lVVOTu+Tob66a3EOqyorIRukvc1gaks9/XCnJK?=
 =?us-ascii?Q?VWtN4pERKBhvhna+ZbmE/nlMShXt/8lToRx2xwCNitvzYOXHTN7XAEFoLO9Y?=
 =?us-ascii?Q?Yoh9kLHK67zmXHJcyaOO8cuNLJRB9UZOFSJNgE1NeBsv5hqcd0wVrUWAYFL2?=
 =?us-ascii?Q?7rnXkAtBvHIRXYCUYJdfQHBekViZZiuG1m0HAJT9tEaGC5Ruxz+S34+u4/qW?=
 =?us-ascii?Q?JC2bAVSNHy9XZzdXrM15SZOc4JSltm0bmBTdcUps?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a4a8e1-d192-4347-f0e2-08db03e3333d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 23:30:55.7088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6SM7So9OZi67Mn7foxPLkFG8mZRp28HGnGtuNVw4NlSOtLb3eeZI9ae8Jn8BRJO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7499
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:53:03PM +0100, Eric Auger wrote:
> From: Yi Liu <yi.l.liu@intel.com>
> 
> Add the iommufd backend. The IOMMUFD container class is implemented
> based on the new /dev/iommu user API. This backend obviously depends
> on CONFIG_IOMMUFD.
> 
> So far, the iommufd backend doesn't support live migration and
> cache coherency yet due to missing support in the host kernel meaning
> that only a subset of the container class callbacks is implemented.

What is missing for cache coherency? I spent lots of time on that
already, I thought I got everything..

Jason
