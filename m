Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3E63F0D3
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 13:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiLAMsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 07:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLAMsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 07:48:19 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C88B1B7
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 04:48:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOPFHVVf5TA1nMCjdB+0KaGJZDl0DP1QPHhRABJ20Knvxe18ciY3oBeRG0VUktttMbhjufqFE30y3EWj/Ao6EfjM5J71JcTCIosBSzt7lQ+NMOSTBhwmg4mcLwf4pWZHMXFYgc2WsMXWgdLTmPouDQHYN1N0ou3NOxjzE5Zib1863pCEn2Q339GP7HQcuxTrO8+XYXPkvKq4aBc3t9JEufFSqFq10z0rcgsH3fNQoY3josYhcgOtZpTO5TXyORJ1PRSSXAhc3ugJpFXZ790Od8770wVphD9dwXjvnUX+8dYo4F9icRkTBR+qdg7y5nhxrr9xKKDRXM+v/NAry4SmqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGgO9HtssinuVW4BoHS59YM5xmJwys4Bw6zWW19cLs0=;
 b=XW9F8lQPbyCZ4IZcozgBkEs3BGf2zfh/m8qnhqGQANNambDhJKroYaW36GtpOaR9k6SHTTeHyZcq5WBSbbwIWLdGC5iSPDIflLhf7vDHtmbjyCM7j/NDMFFaFmaDZw07QD1zKly5DTJG1+C8O9MwjFmyWIfghP3cuP4M5kCBzOb6pUcYUFKP3jdhkoc8eHsnSArP1R1Z+Rx1wrd9Y/qhmlIjZKaS1t9tM014NODF2MFfxFHybyJHe4Zx2fiQ40MBd1OGUwPScqJcjZTx9TQhdTPH7KPa63v+t6sBivNOwUEZ5uM4GZsWU70G57V7Na0EBpXKHh7ls5FPsP7oz68k6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGgO9HtssinuVW4BoHS59YM5xmJwys4Bw6zWW19cLs0=;
 b=lyLLVgo5ysG8ykygufgc/VndD8p4JQp3MAduGTkk+zeG616qXXzeAiDn4ymHTOeZKYfdyD7RrlqtClTixJuOUCxQkTpTbD1GYyJDAtQKOC4SdQ3/BXd4KdXyixliSZGoQpAOmfPUoO5cm6Cu9llFcDOx9ZgPcETEGLEMp7cu9/oxr/nPATOSBw7IpnzbLW8jZVEfvt5chDif6ZliaMmub4i4WNcd8UdjLyIphKkek2OfQ4NWkxixKcHfpck6YIQ6OvDaLLQarDxIZaJKQJZ+6SLKH7eg2iDAmFABlz+eljN6YBGOlWBmTub1D+nH+vhNYJtxcoyEwBEPy07AQjIAng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5853.namprd12.prod.outlook.com (2603:10b6:510:1d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 12:48:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 12:48:15 +0000
Date:   Thu, 1 Dec 2022 08:48:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC v2 05/11] vfio: Make vfio_device_open() group agnostic
Message-ID: <Y4iij7hyD2Qhj/F9@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-6-yi.l.liu@intel.com>
 <BN9PR11MB5276CD3944B24228753883418C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <28861625-d500-e5e9-98cc-d1ea10fe06b6@intel.com>
 <f57fcc1d-a3a4-c423-a863-b1958a8d453f@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f57fcc1d-a3a4-c423-a863-b1958a8d453f@intel.com>
X-ClientProxiedBy: MN2PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:160::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5853:EE_
X-MS-Office365-Filtering-Correlation-Id: 007fe22c-6b24-4898-57b8-08dad39a5096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MG2Y1QglaxFL1YLd3RGCUA4ZEOUpBB3YEHHvWrzt8jqXlpUuqp5I3fXbhIFZmgowDOgTPvizh/Cf5vEopLIeaGvxcgkeG+Uhm724+CJhk+V8sgrS1LQoYS/bvpKi/FGJ0VyyK97E232vY4hJQzo3WIb7srqjU5WQgJ8L9S1xV2743aTAAs6fgETyANvkL0PjnXzlGQruJN0rZK2vBw4f6DfM6DPgzGjl3SneISc6EsuaKVvFMrBuNHdFe6f4Ub0iNAFh0fGYuP7NUDm2V+jkCUb9I28BHn4k2oL8Er+k6nayzMhFnCBFMj1UPPUwGswA7NX4qdfMvgXwnltUniEETmyr1Oqu/EuIe9OIwa/xguBXRf9ltj43qBX7t4YQoOrLodbV7rVWYwcGdTR2ptsK1pvBLRH518PYfJt0sQQ8gx4ScoeCW+c2xNVBS9gqWmwox8QobDnWpJyR3JO3Kpm/PKSAy+6itZnCJeByZdKJNG38EVxPwRJxz8kFMou9lp7G6IblmJWhq1CCRkDlUkpl3sVrYXH0Bdq0oXXM0ZxusF8gqspTpPG0mbvag9dBvZivR6oMVGPVlNxZcr6w626Yyad1MaUpfLyblSXI3eFtUiDnzmXCg61ifdbcydQXLmjf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(2616005)(186003)(316002)(86362001)(6486002)(54906003)(6916009)(36756003)(38100700002)(8936002)(26005)(6512007)(83380400001)(6506007)(53546011)(5660300002)(4326008)(66946007)(478600001)(2906002)(41300700001)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emFqQVVKeGpMWWJkZzlIa1dTVDhZMUN2ZjVVWElTMHBBRkhxcG5lNGdQOWZh?=
 =?utf-8?B?dzlUU2M0Vk52bm1FdytUbWkraDlqeThVOEVINVJhaVlUai9LRTg3UWhPd0pX?=
 =?utf-8?B?WkZhbnA0emNJZWRhbnBPakRQNnZudHUwOXhvTi9IMWxzWEFsOEtoZTRLWFE5?=
 =?utf-8?B?MHhmOGNCYStURGdYV0ZlUTg0MnlEaUd0dWJIWXRRZkJOQkZ2M295ZVNmR3hI?=
 =?utf-8?B?bU4vcWVtK2NxVWVwSjFLdkJJQ3hydW83aHNjTEppRkRXaWk4aW9pRUo4MTFW?=
 =?utf-8?B?SWpMMzdVZFBQazBKUStWalM5RXJGejhLMDFBTkc0d3l6WFljakx4eU5WcUJC?=
 =?utf-8?B?ZHhwZkJUaFArSlRYYVpSbUNyOGwzengxMGdqT2VOaFpLOGZmRUN2UTJVb043?=
 =?utf-8?B?M1pUYzNxT1FSU1RYWFA2UU9YczRNTVFxWVd3bDJoZUYyR3ZGWkhoQkhBMW55?=
 =?utf-8?B?Y1RndVp2c1NHQVFpWHpTQ1RIS3hocmV5bkZhT2J1T1pHT00rNm5JTWRyeDBw?=
 =?utf-8?B?V3VNM0dKdWdhQkk1V2lFc29hMTRmVkszd1c5cGZFNDN5bUlIZjduTUZPMW1O?=
 =?utf-8?B?SngrMDUyNHBpZndLNitnY0RDTmVSME8xNnRSU2JTL0Y5MHJwY1ZXNExIRUd4?=
 =?utf-8?B?YnhsT25qZG5hd3FzVEZNYkx3SFR1UDlYMWVQem8zK3F2QTZkM0Z6ODEwaUt6?=
 =?utf-8?B?Y1VBS2x0dlBZMHJFV2U0NlNrS0h6ZU5HNmcrWEo1eHpKa0o4ZytsNi81QXN5?=
 =?utf-8?B?TDBSRkVzVER2RVVSOGE5REt4dW1DZ0hLNjQ1ZjRQSkxOTnJoVlU1eHRCRzBI?=
 =?utf-8?B?R0hSYTdUK20rY2FJeVMrK1ppcWVVZ2l5ZkhrMEdLZC95YVdQeEFHN0hWcGRD?=
 =?utf-8?B?eCtNMWxLTE1paDJLNGdjYjA3aXNxRFBtcU03QlVaQ3pwWDB3eXVQeGpPZEhI?=
 =?utf-8?B?cHd2WlkwbzdJQ0Y0ZUc0STl6ZEpyL29IRy8yNTZDRmtxeWp2M3ZZaUE2VVZB?=
 =?utf-8?B?ZE9MUEJNYmhSazV4VmFtSHZXMWYwU1RlRE9IaDZDL1dMSnBGaVdzWHZUSisw?=
 =?utf-8?B?Y2tSOXFIY20xTjdQRnd1eGxlZ2JJRkZINXZZbVJNdjVOVlpwZHo0dU50OWJE?=
 =?utf-8?B?Y3E1cXErV3RucmlBdHpXcjhrK3VXWU1KT0pnVjNwREgvaTZsTkdhSEhMdDdI?=
 =?utf-8?B?aWN4NTIxQWFudUtrQXN1cHQzblB5a1pUMEsxZVREZmdOVHZpeVQ0MjhTTlk5?=
 =?utf-8?B?amZaMWRVKzVuN2poQnFFK3g2L2ZWVDhwYS9lUUxKaFA4dlRyZ2VYaW5lVlBn?=
 =?utf-8?B?alhrVGFkY3BFT3hEQk9iWDJUbithcjJpT3FHek5RSXpMcnFyU3F1Tzh4dDY4?=
 =?utf-8?B?UlhnMHJtYklKUGJHYUJLMkRBaUdYeXVtTUNJRmdhR3h5UEx1MTVRU0k3UnRx?=
 =?utf-8?B?cVlXdHVpVlVIUFpDNGQrc3IzeTFNTGREcWFIWmxpVDJNSzU3Yk90Z2VhbkIw?=
 =?utf-8?B?UUVkOStFaFgyWnozeXd0bVNTODM5d3k4YnI3SU1BRUhUOFRBZk5xekQ0dXBv?=
 =?utf-8?B?VUNRVENYcWFKcGExMTA5bGg0UXg1OWRJTlBpeHpxeGxPejFUYTlLMldUYndn?=
 =?utf-8?B?YnJUTVZmU0JzQWZWb2RNYWFBOCtKYis2NmhaSURoL0FFREc0QjdhT0tlR1Fy?=
 =?utf-8?B?T21HZGl5ZmtVT0YveHpJU1JFVWpXSmFjd01hVkRKTUxUblg3aTdQbmZjMEp6?=
 =?utf-8?B?cjdlcjJOMjRRcytEb3FPRHdXZkZkbTJiVHBhZzI3bTcyLzdzMSsyaDBTT2lP?=
 =?utf-8?B?UWZOdFZObjBZak1TNU1HaklRaDk0S0tRSWRWWFZjcm1aZ2xjZEU4bkVTZCt3?=
 =?utf-8?B?VHZrY2gwTzRtdDBTanZDUnU5c1pvNHlIVXlLZVQ0OERPSnY3ZFNoTXRKS2J2?=
 =?utf-8?B?NUo5RHBzaTc1cFIxeFpGY040N05xYUJmdGlNWElyZU9XdFU5aTVlMzU3Ynlz?=
 =?utf-8?B?R2xJem4zWFZTNDJldTd5QkM5U3A0RUNCUEhxeFJxNWJ6MFpZR28wZkZsb2xO?=
 =?utf-8?B?OUdCSmszeThOVVRuUHlsOEdmQm1EQ3ZlR1ZFUDFOcFgzMVJYdjhZNGhib1Ew?=
 =?utf-8?Q?jjiQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007fe22c-6b24-4898-57b8-08dad39a5096
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 12:48:15.8301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5KfbohY9QVaYHdb/CsnFpjN6bK5YgUzO2dAoswX5nWZ6VwnGqG9tg6WXrlFhr5c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5853
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 03:08:12PM +0800, Yi Liu wrote:
> On 2022/11/28 17:19, Yi Liu wrote:
> > On 2022/11/28 16:17, Tian, Kevin wrote:
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Thursday, November 24, 2022 8:27 PM
> > > > 
> > > > This prepares for moving group specific code to separate file.
> > > > 
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >   drivers/vfio/vfio_main.c | 7 ++++---
> > > >   1 file changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > index edcfa8a61096..fcb9f778fc9b 100644
> > > > --- a/drivers/vfio/vfio_main.c
> > > > +++ b/drivers/vfio/vfio_main.c
> > > > @@ -878,9 +878,6 @@ static struct file *vfio_device_open(struct vfio_device
> > > > *device)
> > > >        */
> > > >       filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
> > > > 
> > > > -    if (device->group->type == VFIO_NO_IOMMU)
> > > > -        dev_warn(device->dev, "vfio-noiommu device opened by
> > > > user "
> > > > -             "(%s:%d)\n", current->comm, task_pid_nr(current));
> > > >       /*
> > > >        * On success the ref of device is moved to the file and
> > > >        * put in vfio_device_fops_release()
> > > > @@ -927,6 +924,10 @@ static int vfio_group_ioctl_get_device_fd(struct
> > > > vfio_group *group,
> > > >           goto err_put_fdno;
> > > >       }
> > > > 
> > > > +    if (group->type == VFIO_NO_IOMMU)
> > > > +        dev_warn(device->dev, "vfio-noiommu device opened by
> > > > user "
> > > > +             "(%s:%d)\n", current->comm, task_pid_nr(current));
> > > > +
> > > >       fd_install(fdno, filep);
> > > >       return fdno;
> > > > 
> > > 
> > > Do we want to support no-iommu mode in future cdev path?
> > > 
> > > If yes keeping the check in vfio_device_open() makes more sense. Just
> > > replace direct device->group reference with a helper e.g.:
> > > 
> > >     vfio_device_group_noiommu()
> > 
> > I didn't see a reason cdev cannot support no-iommu mode. so a helper to
> > check noiommu is reasonable.
> 
> This check should be done after opening device and the file. Current
> vfio_device_open() opens device first and then open file. Open file is
> group path specific, not needed in future device cdev path. So if want to
> have this check in the common function, the open device and open file
> order should be swapped. However, it is not necessary here. So may just
> drop this patch and consider it in future device cdev series.

the point here was to remove the device->group touches from
vfio_main.c, which this does and seems appropraite.

cdev no-iommu mode is going to be quite different since it will work
without groups

Jason
