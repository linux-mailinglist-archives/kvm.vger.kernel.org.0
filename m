Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC139F866
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhFHOFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:05:10 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:57971
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232341AbhFHOFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:05:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdPjWSftJHryn2HCMg8RLt2oI4v4zwKaLgXaIk3XzmucHq4Xoyn964xK0iI2Fnrhtk1BY88sn0QAzbWrXKA4wsRovkG3FDVARij+lcexk8D/0OMu3g8aAW9F3nDLta41tcz4NC0K6LI0jLIMdQc/LWiaW+ddSAcuHGQjM0q7snxwRS6X65F549mX9NvwAV7zaQjhocFZjKEP37EufLrXevOCi5HhGG7vPYlSXCjEmK46qFlQ/m8MOgHYYEp7kUVDeSPm5JBcZuerILXVFdXEbzI8Ej0+MwFDt2gb42VoPDrGwtyQ5pv13W7VpIr5VRJOW4CEBve25EAdzlt8TZO8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5xQlaan+iFVPWdVDIpL3FZbx3QCmwtSqX1nSM1KxC0=;
 b=oIgegW/PlLlnK1N8T5QJX2ky5sL5nxHU7+sqh24DiGd+t2qdQbKVs4rCoemybULFvryIuPMPafKDLe1Zp3NPZze4l7hoTUvHVwz6svIB+bLk5rf4OVpqktJxJEfTAniSVkKtJE5Cvh4fj1XVVs7zrUOeUEfKAfrXfZEV81OhRVHlz4GTNb+lD/Em4+ujejLi//xLdNeKK5TeZoaH+qj5FBPMWFy1Nkl8hhCYykPRjPAtRvpA8fcCpAP99VTVZmLsI6IFzv8WUjKu0UGvHTe5onyl/Oc4spn3Y0g4NQJJV5hYM+AeyyJiUIxws/SmKLGR6bNcYB7qSEsRObu0RpeN7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5xQlaan+iFVPWdVDIpL3FZbx3QCmwtSqX1nSM1KxC0=;
 b=G9X2CnBvpF8VV3ysnh1+D3pcFLTBcJm2ThCSY4yn829fNxAAqGbV34rC2HqFBoygc9VZUOEwkuK9z5sfQqGup0ygQe3ExxI9lQu21xDZLmkRXK42U2T0ucknxOIT+Tx5NHNsbN0MZc5L1sXmYrCJD2qzRXZSmwL4f6hQR8jWUdDsHN6iZ7Ko2RstphfKagE3NdGSXW5z3v4jyYZYlQUso/298VdrjToH/pESGL2vrcuF7wd84AK0PQFJZ/bQ/J4bznuqr471W1zeokHf/gOcoc9Jx1qZo5xULk8qjBMbtjHugJLnE/p3/frUMAaTXzPxDO/4ZqKHANGJSn4Z/4w+cQ==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 14:03:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 14:03:10 +0000
Date:   Tue, 8 Jun 2021 11:03:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <20210608140309.GI1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8SdymSgn9HHRcw@kroah.com>
 <20210608123023.GA1002214@nvidia.com>
 <YL9twy33JvsaeWt7@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL9twy33JvsaeWt7@kroah.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAP220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAP220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 8 Jun 2021 14:03:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqcJx-003sBn-Fl; Tue, 08 Jun 2021 11:03:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4946bf00-a35a-418a-eb48-08d92a862604
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53636BF3C189779F04C84DF9C2379@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dh5H/c+Qw03WQp99AVi+2RBnaS22lplf8CfcLR5xfLOfbPKbIGOItL0hvePkTLUqNCrfTuNSW2MKv5ljTC9yYr9DYeRHMRir0oEZby5XKRJWyYqN1HKBjwfKpeYT6BcSMUbbXL0qjcw74UWyNXroOwR63iy1HTPeJjWoJESlRoAkKsO+zklcvAeN+VYRiE83LcVEtP+f3CksI2bY5Wbda8XDBXGE0LpGyb/YNxlzPkUOqrLCbOnDDPzhEz3GfkQVDjJsxpyQM6ppzxQJE6wJ0AwiuRVRKSTaBMkGkN9X4q5v0/1YOChvI0sVpPZK91xguiimNMqtVHgffE3Qc5XrpybxTJB8OQEKT4O+PfLA6s8vgIUiXqSPMbHtOV/haEqzDE/cQSD12c1CFlqGuYfFceJm6pQrwSlUDTZ0Uzty/lOU1tX8jBWgW+mpxF3u1BMm47wzxknmVnGe2HUwPSN0vmBacRbnUDOqiMKGInUfPsDv0iOMKCJ8iyDMBPY+lyutH9obRtxbMDIAyjWI8AMS4zmw36B7XFLiGG4wAbyFKM2Fq4+i36p+M1APgK2WAmRXdHsUvlCUcxnv2kGhG3QxnA8/RMqeYuziUGVE7exsxOY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(426003)(66476007)(316002)(66556008)(8676002)(2906002)(26005)(2616005)(36756003)(38100700002)(8936002)(4326008)(9746002)(66946007)(6916009)(1076003)(478600001)(86362001)(33656002)(186003)(5660300002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aThfiW7UAt6F4xVQXv9bq0C20DsEW552jIJEqPX4kKHQvvd9+7XW+AoXSVwY?=
 =?us-ascii?Q?5VSHkB+KNG9OwDV0F5Rs3WPH/cAbzijdq/lh90Jpf6WzSGd9iDynv8HAUiLk?=
 =?us-ascii?Q?+pKAlRI7XigbIvVI1CT7Kd6oi+PQvHHWnzxy3ABQPbrMoVO27wcqxmY2hpXo?=
 =?us-ascii?Q?tOB48eccInbG9d2wSlxasK1iixXRvNYxJKSLSZvN3nZtuhYz7mu29OofrIpi?=
 =?us-ascii?Q?ftXAI0bgBtOiuYJT8geXkGn26Uz7RFlmK8TWduBZbUI49ZBjAOgg4jlI7kbe?=
 =?us-ascii?Q?/ICMzGpN7IVHo64AkdO7j9aAyTglaZ7iiy4MqIei3jO1MxAFnTjQ0Q4cd8qR?=
 =?us-ascii?Q?1qZKcnR3n6N0j54KE0+XFxRCo/wJ+SKtQRsomE0l3lZCS22j+VfM0WZO0Uqh?=
 =?us-ascii?Q?IgpYf8MPJm7LM85Fzmviw5rAQiQQYvNEOXOYt3h5iXCFkrcfx1w0RqU1hODM?=
 =?us-ascii?Q?a3PPEumFOKmrsF/XZzmCXkarTfQ8xSoAoEGi+SqqwyK/EUWViUlohLVfeBvJ?=
 =?us-ascii?Q?PRuykaltOSTuLZ/NHB3nVZ2d9yuSMGXYs2mVd1HS4GW504rUJd/8QaxDY6dP?=
 =?us-ascii?Q?GqYoXJtWjERdsz4kqzhYEz8Ig6UyafhiivtY3GZmNTimQ9hvKiNQN8zrHkTy?=
 =?us-ascii?Q?bZ1E6XVHPg6IoJGIo/0nUoD7+oAkeJ08o9qGcRPZyVV8doE6y1b5ghPdbrOT?=
 =?us-ascii?Q?HHqrBe39dgy8uPYpGtqpOGUtROkCljb1GxC+/7+to1StjHIVktYcGx7ztPXO?=
 =?us-ascii?Q?DtBHz3zbNSH6CSd5cP+ujMMHBGxxkcpsZ6/KJjYGXcEnsmYa2lOF9spgfD4e?=
 =?us-ascii?Q?sYDNugm2cCwkys8L9JAY1o6PIzrH2lTdOyO9WXFaNgtsl7NOnVbkcu/AsRbW?=
 =?us-ascii?Q?tjx/W8CuvBSQrR/pd+NnLA5PsSa99zI7FanB3PzXLPr46zBuSJPqfiwmPZBz?=
 =?us-ascii?Q?kM++/R8TmZ6jDezCD28lNqfhaCbQRSnvH9MYiWeEJLGwp+UZaCJzwrLk9n/B?=
 =?us-ascii?Q?rWTvLSPAdEtpzAeXFEFfWRzVLMrUcVRksxMhmb1kR+kYJQPDG95bcENYYUhx?=
 =?us-ascii?Q?drmgZOMMmU2H3uuLqk0gTrQnWtMPWa272Z0csEee/LH/IzPK91vMKuW8No98?=
 =?us-ascii?Q?o5/x1rFh784aR+rFYjagYjIwbyXPwHe1Z/F3B5fvYMKrZji5f7a2CF29jTAZ?=
 =?us-ascii?Q?gUVSeUs6YZXFsvEBOv1buHvs95S9BkptrvqG7G7WEtMZ+lZVtqWefSu5b7aq?=
 =?us-ascii?Q?7SDtz5jcTBr151zVH9eKi+vHt/Q2z5G0oB6iwEeqZoS2cCkQIThsoqhltx1X?=
 =?us-ascii?Q?Pn+D1EEp2XuQrLL7N0OofRTD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4946bf00-a35a-418a-eb48-08d92a862604
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 14:03:10.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkvjQTLpV+CMt0kPCOfCSf3CTeWgCyGOJgZ/10ieykQm8N0QSbzpCSAg+sAQW0tg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 03:16:51PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 08, 2021 at 09:30:23AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 08, 2021 at 08:47:19AM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Jun 07, 2021 at 09:55:45PM -0300, Jason Gunthorpe wrote:
> > > > Currently really_probe() returns 1 on success and 0 if the probe() call
> > > > fails. This return code arrangement is designed to be useful for
> > > > __device_attach_driver() which is walking the device list and trying every
> > > > driver. 0 means to keep trying.
> > > > 
> > > > However, it is not useful for the other places that call through to
> > > > really_probe() that do actually want to see the probe() return code.
> > > > 
> > > > For instance bind_store() would be better to return the actual error code
> > > > from the driver's probe method, not discarding it and returning -ENODEV.
> > > 
> > > Why does that matter?  Why does it need to know this?
> > 
> > Proper return code to userspace are important. Knowing why the driver
> > probe() fails is certainly helpful for debugging. Is there are reason
> > to hide them? I think this is an improvement for sysfs bind.
> > 
> > Why this series needs it is because mdev has fixed sys uAPI at this point
> > that requires carring the return code from device driver probe() to
> > a mdev sysfs function.
> 
> What is mdev and what userspace tool requires such a userspace api to
> depend on this?

Were you able to see the cover letter? mdev is part of vfio, it is
very ugly, but it has a userspace ecosystem now.

> Tools doing manual bind/unbind from userspace are crazy, it's always
> been a "look at this neat hack!" type of thing.  To do it "right" you
> should always do it correctly within the kernel.

Which is what the later patches do for mdev, but the dual operation of
creating the struct device and connecting to its driver have a
historical requirement to return the error code from driver probe to
the userspace.

v1 of this just did a hacky approach inside mdev to achieve this but
Dan and CH thought it would be more widely useful so asked for this
series to allow the driver core to handle it. This did turn out fairly
nice so I tend to agree - but returning the error code is important.

> Random boolean flags as parameters are just as bad.

Sure, but the function needs different behavior depending on the call
site. 

An alternative is to rework all the call chains to somehow embed the
difference directly and I don't have a clear vision how to do that
that is any nicer than this.

Jason
