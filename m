Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DE339F7A8
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhFHNWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:22:35 -0400
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:57569
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232635AbhFHNWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:22:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4NEKArqP0IxfYtfPa5f5yz362LLMa0eyjYdSKZyYQl3y71FmKmI7MdgzpaZs1PGD6xZqXRR4pIyqYkxGprovm/2Vlc/3phYV9nqKQC76ffMX8A/1dS1sDQ2YdDpbejmOekMx+U8RuZjV9tGq0XDkDkkx0hzU2PcLm2cXOaLoIJpnj2F29GhGUzWzufPXf7PQXH+SZibTubIOyNcyvFp7ttuo+en01EQMHRByyRuNcnS/9VwhCemmih4J7S67TSPI6u0SuTsWp28IcrtyqmGgpPIx8Em+L96WU2JFeY+NVh5fyNauboCspKXo+QtID0MoQd3Nw99VKHB+sFTCt614Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJiqr7J8AsHQGGVLWyn6aVi87/Dx5C0jrzp5YrP42lc=;
 b=RPG4KxSI54kvseIKUbd/dM6AjAqkmJsTgz+N3p5eGms7kkN/tbzI5dmsJ0XwUF6LXQyQ7W0kDNvXLvYPB+U0c2IboKCV+EMRGMRYxIzaQuOYUEEfzY0D6/KppeYXmYXXoemC14byswZKOQhu4PUoSYwknQPjo6aT4a7Zo0Kzuo8TNdET4+AwHzZqE1cAYvrHQ8q8cAZedOowFLshr7d5uS5aICx3nGtI0OXX0JQ1yyj9eueT1ucnX+Rt7wyt1N1VZiT68CimVt3KggKlNTDnG2aaYK9GTuaW+NNOVTPRA5ofb/ApESbruT0n6Vpkd05YD0Cc80kcZ7XUv1I68BFskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJiqr7J8AsHQGGVLWyn6aVi87/Dx5C0jrzp5YrP42lc=;
 b=CZLMqSvbXtqCBUaEZ/AApCSu5QQrgYM+uVjFxHCVKrwIchh3b/cKAlt1kUASOC8IdqWz+6moLRBIKxhStVqJ7Hip6niZkYb0Wz+qIN+Z29GercFxPF0TTpiUige/vDeE2oz19MF/mB/cBIDTXofZjvTO7CrL0gEGzPsBlJAEpK5QqB9en8lz3bcwxbDdm7OzOtEkm8COJ0Mic6HsAYDQSYHte8GvT9wh7jSaLntxSr1MNr7Bo3V/0ODvGmXq/t3FhbwIIfHoefDCJM3GQgwCHHBIZ8eqzxJgcdvtpCCIwzKm9AYnWy8YbI6usq5YrPqmOgUAx9HmB9glsg6U0v8bGQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5077.namprd12.prod.outlook.com (2603:10b6:208:310::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 13:20:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 13:20:40 +0000
Date:   Tue, 8 Jun 2021 10:20:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210608132039.GG1002214@nvidia.com>
References: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:91::38) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR05CA0028.namprd05.prod.outlook.com (2603:10b6:208:91::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 13:20:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqbep-003qg6-Ag; Tue, 08 Jun 2021 10:20:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79b90f55-5e0b-4e80-e14a-08d92a80362b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5077:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5077CF24C6769FCE8890B28EC2379@BL1PR12MB5077.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVWHTFKXwrzGEGk6J9sl/Ei6+5r7Qy5Oe6SWvjVgc4Xwo9Jx6oFViL+eSUG49cXgaYSgjBOBiTwcBMB5Ng4pidk0jsvzqBB/2iyBfOxxrZe27dki6/xZkEbAjgcLIen1uL8E+eFvRgtbVPM4KXyIxkNPnSRI72E6Nd2rJtCUIkNa4SC6MAzBBrSrU3dFUZ2pdEh7NnIowDP+Lb7h1VaKF+XNX5RTBkL46SrVaodpIWxYnxYTu/4qS6hbVawNQ0Z2XpIGCtkdqp43iIG3SHa0Jy5Zov6UsAkMvOn+OHq8VThKkFShSK2OXhlBP+q0oFlJnz/5kfXjV+BYNtFnjeb2cNoZ/YhH9nfrPGRQLEomAC29/rHRFdnLKrO82evn1yexPx1edDfldDZvkmUhGBfWb7uxmypOydIu/VINqekdG+zNl7W5J3CvxFYpJQw+vnDjSPzOW05w3tLleBJlk/DBSnSO9jmUpYaVUB9jIav51QwBljn9dYXOQo0TB1Q1gXo0Ea2N9iPW5kXmudKwrLp2lc0RVBgTlKXmwRrydEffx43Bdbi5nrWSKk5MyHg7fmfbQxg/BOFzKevPXUNhRbQqPmGEW306chEcRAMMmb5lSLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(5660300002)(316002)(4326008)(558084003)(6916009)(54906003)(2906002)(86362001)(7416002)(26005)(186003)(8676002)(426003)(33656002)(36756003)(1076003)(2616005)(38100700002)(478600001)(8936002)(66946007)(66476007)(66556008)(9786002)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XhB1kka6aub9Xy5tQRG7/RZdKGhnJ3A2IfvUBnOu5VA0XOIq+LO+xTAPR12U?=
 =?us-ascii?Q?RTisZ0Mhw3JBcHQECVR9bbtnrRGGzH7Wm6eAI4qvoUiCYdv0HL1vaAH5rgqM?=
 =?us-ascii?Q?2/wjdSD+rbzMOSg0bnSk+bXXm/2E8GHNznjp1QshrXZU1SKMK5l0Ayx8T5pQ?=
 =?us-ascii?Q?9corHaYd2ZdS9kSIH7EXFdPDba89FxMS8o7c7/geNf/XlIAUI5ggBIkuyM3b?=
 =?us-ascii?Q?dXXXCpzJHv/te7e2jJ0rAixUopwYK4Ls5OwF0aHcOKcUmBC5EJyKH+jTa3bz?=
 =?us-ascii?Q?zgIQvTy61NtVLdeSeIo7l8QgjxcBnLyqKewFShHB2FRYU3V1Yux4VZ01CXPQ?=
 =?us-ascii?Q?MOF0zuWRFni2VVU3iK+eQ9Y++5fNmUpG289TLL6s+HJfiyJ2hD9EJ7VJqjog?=
 =?us-ascii?Q?R1PrUF1F4N2JlYesDNJLUF00MkJWECVGf0N6LzRSdoX9E/Kq0k5n33aUxK5/?=
 =?us-ascii?Q?eRvYvTjTYwi7P+CA4fWvO3TZX11BhpgfI9EWthnyUbqNRzK4XCgBiBw3YgDi?=
 =?us-ascii?Q?eHBzONYpZX5YtnFHYIs7rBU7R8k2711yZXwacFbrw1CKBGk+ppIZJ1/svXh1?=
 =?us-ascii?Q?lwKZY/n5vu0UJxfYWm0UfQ+3Mj9Z7wxuguTOdx5RibEBQVd090HRW/RrXym5?=
 =?us-ascii?Q?o9LVeJonyckW8FLiQzeZA4H90R3JLBxeWXDllOAul3z4ObO5CjHLte93Zkid?=
 =?us-ascii?Q?sd0SGdN9zEmq6roaC+wcMRLZh3xn4p8glvuyYXUGEpXS3qJ18BRLRK23VU6S?=
 =?us-ascii?Q?5ZXHOdYpdiV3n54OLmaUq2I94Tp5kiQPESU24vWNYJ+IzJwI46J0dNAphooC?=
 =?us-ascii?Q?SjdxS+konB/Wh48K+WIBmVPT97AqGJHNiiNoDjVkY648pUzc33hvT4Lb1uA6?=
 =?us-ascii?Q?AoPWHQAjVxdkYCCZ2+Jlcfr/PTg6lUOQCSZZHP8KAKK8PU2Vwjfs+qvWccTc?=
 =?us-ascii?Q?Mit1mRZbzSgvRHY5zwoaprEEB/zQWgMKw9M1TGfHWVDQCtMfg0PR14QbrYqW?=
 =?us-ascii?Q?vZq4fRSjcToAM+4Mw77Zf2j031sCCM/ZX5nztvrNJ9XUc2mDJ6pQpxiuO3zp?=
 =?us-ascii?Q?ZjcQtlcsywLI5/RjKKiUyOc0VwBEQOTct4HPc3p0zFSzaWucNBuSr/ZgpH3J?=
 =?us-ascii?Q?Z/CP6YrlroYk4ApsVtOPWi7cbo/S9wOptux47T/60BcOzwvDrf4Hy1oAPxUf?=
 =?us-ascii?Q?w/MtTm1BIRcpVALhKe+vJhArPs0vYK5H/vKYOZxzhd+Kn1a8OAR9fAD//q3q?=
 =?us-ascii?Q?BYtiwO2jXfNC6VZvP5RtmtHwpm6XZAuOAtLYrjZaGJ4//COc3FX+ldcEg18G?=
 =?us-ascii?Q?BwrpRMhyorp6knZ1NjsBWf5t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b90f55-5e0b-4e80-e14a-08d92a80362b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 13:20:40.3926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtcPwdBMKgyd93fjn8Isp+5ZrqlsH6izMbZuNHZd4Wp9e2fgjB3M8DOUGhI/Irnm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 09:10:42AM +0800, Jason Wang wrote:

> Well, this sounds like a re-invention of io_uring which has already worked
> for multifds.

How so? io_uring is about sending work to the kernel, not getting
structued events back?

It is more like one of the perf rings

Jason
