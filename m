Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B290065F79F
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 00:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbjAEXel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 18:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbjAEXeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 18:34:37 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C514E71FD4;
        Thu,  5 Jan 2023 15:34:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0xl9Jeu6YyRHvAc9SWuxHLRF8cgjqmiuxZwmnke0HW0LNtr/BsNx0gUqHGCaZ250i2j5UlFJv5rYMFtvBn+15+w4YR18sLxZqGDfs2cbuBqY/hLRpTYqwzOPsx1VyYn64tLo+KJ92AT6X1YArKXlFYTmnicVJT8L+iXk3dVceaA4TkrYDWuNvk81lD+Tqs425kex+po3qwxWxiSnWrYbcKK2rMRNwxqxxRMvMZbz2UVaJbeci9shtCbyvp+iciy7HPqvyooUy+B9WxMcLItC34aZ9qMe/E4BzLkkG2GNyE/wzck0UrUhJQ7Qq9uUJCKghW3OF+2htfIiGAD3kZYmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB4Ls5mRB6gC8zZa89OhEpXfyEBQ1BLtaw/bEOWDQxw=;
 b=eXdMx3sC6bJ4RVTv1Da35gX2OXhXGcCvIPr4Yoj8rHzBrJfNso2YIX4oMtaQ7k6wcrS5KH9bfiXGGJlm80f2Mbkgo8+G2lFyLokq4WUsrZcrb5Q9gdScuYDn1sPK9Lv9WR7R5pPqHV/FPMOI5UQTtOiSiIE8C4Y/GVAuYSotopfHhr+tjAa9nXC6BWrhDUCaStKID76FGQjG0UBjyNMot1X93tkjN9ZQ8PoPkmxultzr8DuFL4ov7hbhX+IOY9lFrftXgJ6MTCi/0vP1b8uSQUo44oYMjRr7MJD6RYmmHxrv1N5rW4DnPKkKmUgUH30W3CkEOxlqQDtpLpnrDISvtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB4Ls5mRB6gC8zZa89OhEpXfyEBQ1BLtaw/bEOWDQxw=;
 b=pXR53lRt+OAEauZ5fL43Ml1buLGHGwCF1QEaVEkYTVmSbvZh3D5BXRXQsJrGPVAiOnunsrRvPfDyh2Hach2pff5NJr8kk8BNtzlomgMm8NLPrc8uX1v1WC/1tqh8BWaC4Px/cBV/LG5dblssCxltjXap0p5VXQ/z7dOGfiHOsZQ99hSch/qftF3Ye9GsKXrogbawgrrxpKZxlEpg415SsgSpypuSXL+10bNu/tHU7/pSo86H49hiNmZX2t8rk2jUUVJzXwMJwyJfhFcEDSx1ecdToW1o8fesy9ecPGiG+QlJ38rcDjtkEhTXun3FvCLUibB2idVaCynb9e7QVyQ63A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8359.namprd12.prod.outlook.com (2603:10b6:208:3fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 23:34:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 23:34:32 +0000
Date:   Thu, 5 Jan 2023 19:34:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <Y7dehnZSC6ukNxKU@nvidia.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
 <20230105150930.6ee65182.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105150930.6ee65182.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAP220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8359:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b83d4e-c351-4777-a0bf-08daef756566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXLEfPyyXJVFnIrAEMPtdWBsw9VXwCe72+dSQFxKEx0lagW9hyciOXQEiIGdwCpJWRDSQsu+iIeiBNb/sgwj7VayY+2Dn2+5OWQXm4vRiTRCcC95lmQWzEQ9NhGMSq2x1jCWK8WIb9fbxpMmIIwT0tYc02yUNac4DwjcsuCZRnrkFlRcE5Nv2kG6RM0Ftu8GnXur8QLRcuuSRKozPS/zc12Xv0PzfU0eip9qqNe9vK6WgTKbAfarudr299W6tgh0QuZhjIkdh7YMn4bityr9aksf3NOky4jFcJoVYDHuh0nLJDGUk+4jOLdX3DWhI7q+SH04U01Z90q8K1fvcI+uOm5J+7d6LvPaRwO0IEiMoVFy16Qc/8IAVUECN5TQbmlzYvRZ4kvS5t2Q7/hVJjrOFevY6hB9fArOoIGyncZxQ++MawVdc+StN3Eefk1b/ygnyVNDM6u9NBVBV8LI+SI/BxcY+QCHifMHFIA6ThOIAPk2EiINmG27yDQYmQ04ht9mChcS41S4Rxn8xdzaB7t1Ewdn8f9PuXzEmBKLswBHJNYz6K8lhw8QxcNrGByqbJwpPjUN+MW4G3qSqS2jKQ1XI8LBPEIPo+gkpINd55FhXv6z98fCAhlIuAmMiIVRER7KS2DLvKfIbaMZG7E6Gk+EIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(36756003)(6916009)(86362001)(316002)(54906003)(38100700002)(7416002)(6506007)(2616005)(478600001)(6486002)(26005)(186003)(6512007)(5660300002)(83380400001)(4744005)(2906002)(66556008)(8676002)(4326008)(66946007)(66476007)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rkBcOEQZyBlkCrec3N9dZwhxKCvZmNWrysTh4KelHKOAQYPZncwFU2ud4NW0?=
 =?us-ascii?Q?NcKd38q4/Y/pbMYNJmQwJDf+Apyj9iRrk0RGJsrPvM+kQhfkCp0D04CU6Vur?=
 =?us-ascii?Q?FpcWC4whJmI6l9dMT24aPiVsYNiTQciaSO11J5SyqwxqFb7wEI1LHP5Ml6V+?=
 =?us-ascii?Q?kH8MN+fP6VIn7yTLHcOYUXdz1Dj1HBxEnQmO+r6GnKMW9lYOmv80jDSRagIR?=
 =?us-ascii?Q?CiSrM+sF6xcDSPO2FsoPMi4q+LNyddCmLHA/BycsOxzPcuOH14nQ0f1S7cPQ?=
 =?us-ascii?Q?TPHxxNpsQmxhOyI44rAasRnP86UTjntIoMEH8DF60JUTDR3hL61H9Rj9qR08?=
 =?us-ascii?Q?gEsKP8uut27qSQBicXjH4SV6ybgIGh3yaTUy2n+zXnaXdfBm9lSkOvyBlhcN?=
 =?us-ascii?Q?JHX5qmUCk8sQrLFdQIZDzUEGcXlo7DoUb2i9FA/NQD5LJeMn0PpDI0JjC0ou?=
 =?us-ascii?Q?9fdlsmwxjg0/ezvMmo9CjQFNlMBv+yRmw8DP/2EnItxjABc2WmKzkNxF1TaB?=
 =?us-ascii?Q?b0a106FBI7aWNnBMI8+qjUYMW12369Ok+DFa8jcHgi2IVZSuB4OW7udfZFNn?=
 =?us-ascii?Q?d4aolKJYC4Cflh3cViorax/I4GDSm8+FnKFok3BHryilO4a0+FGnoVhcjWbT?=
 =?us-ascii?Q?uyJZrMk4E0iZ2NsBfMUCIKc71WasILGRD6SSVAmkXJ5upfLl5iU+fY5g3Qbo?=
 =?us-ascii?Q?CnT+L91bh3HcIef8FlOB+XGFI8HWUMA8wkN0SiDCw3bKlEWzr6xe+w27q5FL?=
 =?us-ascii?Q?Qadat71D/iiMthjZzjptvDlKjzdGEWIVMOOle0WpYaXmV1/IVKYNtlUNptP6?=
 =?us-ascii?Q?SX9/4lrx8gvtKB+JbkiuNw4CCt2TVRpaR7CMFU+YngOk3YoKgl9mwmhIuEfA?=
 =?us-ascii?Q?FvuiE4wytDnaej8GstaiVCL0VqKyTpAtZ4KXUxJhLS872/uhxMwQEcBDBma+?=
 =?us-ascii?Q?CXoqHhRdkMTllUuv9wh7aaMUd/vfu8pfUmw6//rHCZdtEqN4mAbaPwjsmWu4?=
 =?us-ascii?Q?s93DpRWLtRgoMfgeslk5iPdfXhed4Kj4PIwvOVrh5yABBHUH5SjIbuc/j9mu?=
 =?us-ascii?Q?NQvv65Bsfc+s6A87Oqh7ZzgnEPEU3U+4VhBLKL5DD52vTleLdWr68/FJ4S89?=
 =?us-ascii?Q?zNz3X5Qr9QGax85p+Dio8aHgAlocU1kXxwLecr+psu0lKbYJQkHtgRZ7zTd7?=
 =?us-ascii?Q?DALNhI0ZXePSGplO2Gn3laiVvWtTsDdcgeXtLWuE4edfHrNZT5pVegpgAtEy?=
 =?us-ascii?Q?3VlEItTo6o3WrVc+8uKH6nqmHNUMjiDU+ZhEd2xebHYeah8A6SJQCnCo/Wzf?=
 =?us-ascii?Q?yJ+7Bw+nmg3jb54WXll5fI9lqDzay2Ti0PYJ+7brUO+cdbkxR7UXl3kPAiz9?=
 =?us-ascii?Q?oClTo1hS9RhxeRiIB1fQ9HI8Ua2Dbv03rzIserH2zLp05ybmrOXuon8nGZhh?=
 =?us-ascii?Q?PadIDy0ej1CqrDeaEavMk+u+DqYsXj9wP1pfdb63k3Ikv23JbyaMCyMxWuW+?=
 =?us-ascii?Q?Y3V+LYQ3FF9TuGDj/kwXgIoL9vfiMh/vbMe8aBy0E5xA5o6+Kc8bbXwTua2c?=
 =?us-ascii?Q?jGyYvWe6A/EgI3IXxIJta2e6t/DRC3jOPUnZvAhX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b83d4e-c351-4777-a0bf-08daef756566
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 23:34:31.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B60D4lLUZ1xmsCpFppI/O0GyxI05IXu2uL5dA7+kC77zYnBc7k3FaDkW5lIkdllV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8359
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 03:09:30PM -0700, Alex Williamson wrote:
> On Thu, 19 May 2022 14:33:11 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > Rather than relying on a notifier for associating the KVM with
> > the group, let's assume that the association has already been
> > made prior to device_open.  The first time a device is opened
> > associate the group KVM with the device.
> > 
> > This fixes a user-triggerable oops in GVT.
> 
> It seems this has traded an oops for a deadlock, which still exists
> today in both GVT-g and vfio-ap.  These are the only vfio drivers that
> care about kvm, so they make use of kvm_{get,put}_kvm(), where the
> latter is called by their .close_device() callbacks.

Bleck

It is pretty common to run the final part of 'put' from a workqueue
specifically to avoid stuff like this, eg fput does it

Maybe that is the simplest?

Jason
