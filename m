Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D54493E6D
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356178AbiASQia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:38:30 -0500
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:53024
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356179AbiASQiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 11:38:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKaornmNxPmT1EhcduZ2RrV9Y68wbn8H4hi9NGrRzO43znW7zX/h1LQjfFRS/nuaotNFUEjXZ2itnug49a43Z1iJQfk2d/V4OBlzyQUaGE9KGju4sgpBQdZcbr+02eyle6hnpLoIVybyObbGH3EPNdzu+1AsKLHTd24YdDBjVk3IuMtwrwFHLHz71MR+C3QNxCMq1B9V/TRwPx/Vf8ZCYETeIzHAO1J3fcI7dScbJFYWManEysVdQh0uzcyybU5aYwjixYif88MVE9CKldgxs++3lwrOvtmaV4V7VB3jApkKp9ywajUEisMFBbFWDuEWj04s2MvEJO+pHqdYeU5aYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZg2Ie8fWup5wJlRD8ckqfIZ1y+rRPZ/cWmETFY9c6c=;
 b=EtSxqoCxDD6zyVlgeALw1Ojocb5rMG6opka6NjKkfkRRh+NEVj8M4ou+bf4aO51rAjba8p1tXehD/aJK7pSTfhyo4RcUtxMAACZA7BZEx+yMgXH9MBvJoJJ0C7mz8W1VcytIZZulcGUczhXSbEigaU96JoMvu9xPkbgunbD19FdRpTy9GNbNtqgY7q7lpf1oC3RO9jKfZkf8bfXz18+79sbarhlg3rMXo1SM9qLoxH1DEbixi4g76iYZ+xQOWdWSOrXY7wqLrsnCAWMSq1M/GAomrZhjbrMisJ3hWVZAVM09mYsGKACIFGRIdfzcYTO0cLu2tMjWkEF+4lGHM9L13g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZg2Ie8fWup5wJlRD8ckqfIZ1y+rRPZ/cWmETFY9c6c=;
 b=OIVKoWcA4ysIxHu++eeOJsLwF39WcVsDF3ZqCUFoHeSEHDoeMcwJKYZQrA3NJvmSbo0sD4aj5p7M4/JQ+pTO+iSS1u/RV81QPg5jr+XOV9u0miL5KyZDjEJQDrAN+LiRpY7u+0zWHU9S5xep5vkWSYRya33qjiyltAlrY0o4at24GCSscEbwzbVOkyQp5tQp6cDXzWNggD0sERa803xPsYUid4L37DgVTQARLpDjxM7sb5iXvwALhI0Ikiuwf6oeFsAYj5ACc09EnpZCmzaA2lHmRDKDssYezcrroIva2CQ0C0fbPtEm/zS+kch0wmHgZjTKixtCRTk3BNeVfOamWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by MWHPR12MB1584.namprd12.prod.outlook.com (2603:10b6:301:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 16:38:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 16:38:22 +0000
Date:   Wed, 19 Jan 2022 12:38:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119163821.GP84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <20220119083222.4dc529a4.alex.williamson@redhat.com>
 <20220119154028.GO84788@nvidia.com>
 <20220119090614.5f67a9e7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119090614.5f67a9e7.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:208:23b::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc4145e0-17f6-43ba-6023-08d9db6a1b77
X-MS-TrafficTypeDiagnostic: MWHPR12MB1584:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1584B268FFDD27DCB7D520EAC2599@MWHPR12MB1584.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Y2xQaD+hEhlAXmiBcYdRbtP3DJf1e0G7kPyn/GGYil2RfMyb4OTNNFsLCjPD7KFYgsrFADu6zPBAE6QXmwovETlPhj1sjuaJRCWMWpWCK0VZR275CdUnQp3m1wdWDZvLYQuvFOAA5mQlY2tHsQlkAarB7Fz2j1TYYNAV/uUaRQg7VLyjrcZy/40cBKkNcr4ERF2SVBeMnQM9TciVuaxkKvBDKJ8g2is/FU1n58/Oib1sD5I7yD7p94Qscf16C+jI6RBreBSWCxRCDJv/BnVOasl+7bQ0tZ7b/C7H2o1mWURTDpDOuA0gQQl3hmzBXHzut6jpKm7z9R1yofk4CUF1hMy5EonHWUcqqDEEXzMf6f/NGCYIJ8qKULFyYfy9ZqNJfey31i0IbNdxaqaHjDFbms68dso+V+qMAf/Nksf7OxyUkR0f9kQ9YhqvAgTaN7oe2STqrdhvwlNj7mrAHZlcwa+gdFnv/iUf9Sj0K0AI3ZYRYOZjaQnZ64NNFT0eSfsHC5/CMqLFRSBbf3qCVxFvNdUfsuKDWULp8bTTT2cHbD2uRaZhtgIylEhBVYe9usQeBzQEfbcz07swgfZ6wdvwhNMTw3qpuNHISA4v5c9U0ynHt7YO77pt7x9pZC5ZfqNV7z0rUJQxTun9p6BUjMQCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(86362001)(186003)(5660300002)(36756003)(4326008)(54906003)(508600001)(6506007)(6916009)(66556008)(66476007)(66946007)(38100700002)(316002)(8936002)(8676002)(33656002)(26005)(6512007)(107886003)(2616005)(2906002)(15650500001)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l6NiJ0GTQRsdhTOR7NZG3e4n8dkKGVwy5kq+MaNdLa9SvjsOvxb/BbjZITYy?=
 =?us-ascii?Q?mb1hvZMPxdxh50YvgL6mzQkAmNDq4t0jvskMgrUffxKwENklyv3UnbHJxlfZ?=
 =?us-ascii?Q?OJZXXAwoCiZhc6EkRpkCXYTUYW5QJEx6ADS7rFotVGbKuo6+CYB/sgwN8J1K?=
 =?us-ascii?Q?zIdGL+bTCO0POYDY9IFc8bFGd1S+3oTBADIgotbo2AM+pdt9mu4VYEV6PQTE?=
 =?us-ascii?Q?4DfS7WeC/guS2kqCjdR6EmlMjCHnH/FnL9uoEGFkJfzzt82v+ZpNc4n9Nb3+?=
 =?us-ascii?Q?7iZJb7H9k+X5ZcKN1Z9hX89CqurtxlY2HEGZSoY4l5TgPdL3TO3npIzbBd8i?=
 =?us-ascii?Q?JFbJjI8ZaRfdeyggtaDs944EJni7QBzKcsZDBTB5lLe0A/Wam+3fOyvZ52Q4?=
 =?us-ascii?Q?ECgWEcgHjXsGiL5yb+34H6juP1KSSndLrHHKiSgQwcZZ0J1ZJz6npkSi+vIg?=
 =?us-ascii?Q?4PteNnqtmOIowrl2Ug7dJpBlYZMoMJugicvA9TRTJLpYdduJeDz91HjEZUeE?=
 =?us-ascii?Q?qIvTbQceEacwykvdfdjjWQu3NYb9cgfHVBP3XG35ehXCefqnlpxZJMtZHDLP?=
 =?us-ascii?Q?UIg9cgrZScTt6YBMkqgbCOdwSxnI8EGymjKlzA4VkgSBxjEKQxhtAEQJHDbC?=
 =?us-ascii?Q?csfne4O8Yh5lPfS9LOAjawGD8YQaXUi/H3fp0oDyWejP9KzdphJbviWtahE+?=
 =?us-ascii?Q?R6bmud8bv2RJOKYpP0c+/+stLqBsw0i+NyDy+C77SfcB/lMobOaA19SGu+K1?=
 =?us-ascii?Q?BVNgXggo4gP3ufTPxHZEwT+Gxjrvsas5BVUrdghdjrNP8gJuRbuT239Womwy?=
 =?us-ascii?Q?ANSOQ3R4mBevvoW8JpSYUT7KjPgORS3EovFwTfNJhjC6Sqntn3OFRDt/1PC/?=
 =?us-ascii?Q?6XaHMeEFj6yDSmBnY6NKtOkUg/kvSXcHXjcgq5c7Q8bda3fXU2QDgSy+fSJt?=
 =?us-ascii?Q?4KR+rU5g3iLODxeOYdMKxBeSp+l90/Kzxa59631zAbjqX4wlIUxZRWiIXf7U?=
 =?us-ascii?Q?A1Es5rEBw5qCib46MLPMJvvpDVLFzJdkM7FmxMbXuRiMaj8KEgDcNrSdZ3UG?=
 =?us-ascii?Q?ZQR6U4gmILecQq/QS6qIHbFXbO5Uhspsl98GdHoNuBi0N5Le38b/JGZjqdK7?=
 =?us-ascii?Q?mYDYN3lJ8lCuDhuSikNuXYD5sUx6u5mSUekUXkSIBAnaL9LgL9YCEkcBO5vC?=
 =?us-ascii?Q?ELzKEVH2sxr+lJpLt2s+BURFRPtSHGVPTlIfG/qbVn0vX6Vz4AwnqJKyNlgY?=
 =?us-ascii?Q?5PHZStPzffgFe+xXr18xyS+4q0xtU/O6iAB5EwUdBrsreD6OQrQZe3MQSY+I?=
 =?us-ascii?Q?+GFQ6egJpXHItJgQ3oe5kpyembGeQQyg3WZZZ5TU2sGFciyyO2w+EXdbMW71?=
 =?us-ascii?Q?ueDiUdUeN0buDSn3+vIgnLaML+jh9BTfukClpnHtW2fRMqMT+mmVTZkcPj6b?=
 =?us-ascii?Q?iYpHdv/BAyjBYDdBhzu2gYy3TBRDeDOSiyX0Ll2KeXmXhe3V8Omqrz/3S7RG?=
 =?us-ascii?Q?+jCs3cZEZVTbAINrut41ldu4z0cR9RXULnFkT9/UoGZuq36SAAwVKEoD0q2s?=
 =?us-ascii?Q?ko3MoKtEo0cI2E4HiMo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4145e0-17f6-43ba-6023-08d9db6a1b77
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 16:38:22.5803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7anOAzr/6jtUuE2LLVBJFzo3PywhD+eKbhoii182N+HbybnCRjFHT+m8fNtnndb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1584
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 09:06:14AM -0700, Alex Williamson wrote:
> On Wed, 19 Jan 2022 11:40:28 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Jan 19, 2022 at 08:32:22AM -0700, Alex Williamson wrote:
> > 
> > > If the order was to propose a new FSM uAPI compatible to the existing
> > > bit definitions without the P2P states, then add a new ioctl and P2P
> > > states, and require userspace to use the ioctl to validate support for
> > > those new P2P states, I might be able to swallow that.  
> > 
> > That is what this achieves!
> > 
> > Are you really asking that we have to redo all the docs/etc again just
> > to split them slightly differently into patches? What benefit is this
> > make work to anyone?
> 
> Only if you're really set on trying to claim compatibility with the
> existing migration sub-type.  The simpler solution is to roll the
> arc-supported ioctl into this proposal, bump the sub-type to v2 and

How about we just order the arc-supported ioctl patch first, then the
spec revision and include the language about how to use arc-supported
that is currently in the arc-supported ioctl?

I'm still completely mystified why you think we need to bump the
sub-type at all??

If you insist, but I'd like a good reason because I know it is going
to hurt a bunch of people out there. ie can you point at something
that is actually practically incompatible?

Jason
