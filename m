Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BA436B9C7
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 21:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhDZTIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 15:08:11 -0400
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:4352
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234229AbhDZTII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 15:08:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dj/QwoHezzZIhnkcv2kOMNAILepvQSs+RjjNBa6ehcFNUyq+OYMH7aDfMeAoC5ZO3uM6cqObbrQ3t8I50VIgb6obW63wtbLxrczH8Wb6fzQlKx1SCYQLsFfgWiuHcxQFoDY/61TRZf1UvO6YtA2p5oPe4M8/II/SY+t3QI3GVSotK6OhMjNi2J802uuJyitoNH8UTlRk6nz7pzugRISkl4hWOVh6U69ORYoOAyq8Ls+zEvlThKcSCystwuVgSZV2uQnaVOXZjJ97USCsoAwylsAe+TxTHu0UnGB1ZIJauaFpjVyFTdLw+vjSu4xNah//SBN63ZXesady1dBYZu2tkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF468nUO0oiKl1suS748PYNOJH1AoZysSUKH4WhL8zM=;
 b=LETqAkwhDxjIdVJ9yrrHuPJn63Ph7zxl1xB8hlNXg2PZA/ArP4CW6pwjcV9Np/UQnucYXD3wsa6+4JL/YpNgjzHyv10hx81Ox+5l1hoLT1Q2bPwXsn77hPa8OCMHFQZ42BbYJKMSX+B0xuN2sbadJQmhIUCJ0kcDXNU+Aa6iy07gAzen6RNoF0pPw+KZLdwBLfpfqMm/mkQnMiM6slIu4yKIvD2BK66vYvTX/VijBlwVZ3RlLbeW4Ec3ZUZhZsNg81EfVFqD9XSby/HE2Ng8eqbSmhbiZgHEdcv97TfXJAXyv2HJMKnZdqROczo/EIRFUnPYLxr21sdzcCe2s7fffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF468nUO0oiKl1suS748PYNOJH1AoZysSUKH4WhL8zM=;
 b=Xi4R0ucIh7mZA/tG9tfbd2DhUHc2v4Tq0L0pk288ha4hcLSyNtAG6pXLr4QIOu2ozo4Y/yHqpAfAIqK2m/7iRsumLKpIuxgfKSip66600M88QByDJ0DzFqLXgKg1JNEow0ZSbwSMJph2Y3ZVrMf+OX2+Rz+kVfz+/Pl3c7vP+pAhT+CGnmZEclHmoA+7rCuZlWLL7x8ITpWJOC/91Img77TI73os9PqkyDW6E3KKnot2sz0ZiDqTUW17/MvcUCJxznagQAoG162Hn4JK2kBBHx37DuG4SUZMnq7Bn8QgjJ2xHZCqtDGrLwFSJwCWjve8q/2YqaBVRba7lvLQ74ONtw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3020.namprd12.prod.outlook.com (2603:10b6:5:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 19:07:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 19:07:25 +0000
Date:   Mon, 26 Apr 2021 16:07:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 11/12] vfio/mdev: Use the driver core to create the
 'remove' file
Message-ID: <20210426190724.GA1370958@nvidia.com>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
 <11-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
 <20210426142011.GI15209@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210426142011.GI15209@lst.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:208:a8::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR12CA0009.namprd12.prod.outlook.com (2603:10b6:208:a8::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 19:07:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb6Zo-00DDnf-4H; Mon, 26 Apr 2021 16:07:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4f58452-6a13-4e4a-85b2-08d908e68722
X-MS-TrafficTypeDiagnostic: DM6PR12MB3020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB30200CFB3B4B010BFAB4B23FC2429@DM6PR12MB3020.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CN0PVO+MqlSfInmzEZKr908dNU9eks4Jtaf6RStiPw2V7qS/l3luwf4sh6H5RatqifW9P0NLYveJzFCEzwITfvr1o6hWpsORXTmHj30E3lC17CU+eD8Y8Ubdvsjm2ZJd7ny3vz3HkgYcH0kmmANOrQTGIlIgVJokaGnVjiCPUNrf0ZdTHlJewxzGZoWIJbaHNyiag1OfxepZACA9mjA41zHvNUJa5aidb1z/SAVjWMHLbAnYBXw5xcqd9L6PoJBOrKtPPePLNn898dcc0kdvMafnpWIWN9/+74LBO9c1wUajYDNAPC1LADRQcZV2sPoBoMXExZg+jiPX1cdM315xzZ6OJhOL5gNU8fOnb/T79r9IcMj8dsL7Zjv1KWX8zXcz1syi5MwuVuIvjSY6nMf8jC9TRFSYXNV1je3bqqNtASu+eefbLyuX2DnHVpAjbSmkttg1R5jh8uRg8UXxhdsER4cZzAdv3L6VLlvTWvCJe+ud/T0UaB8KprE1ujkTNz9XBzJAouXeCgbZNnxDTBUItUt6piMlOdfbt79AzZ/mEjA985MDFkXcU1q5MOtuMrq/ngS8sX9UckBK5/hNRWhEC6keg9lOL8VNm+pOMZQfIw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(54906003)(66946007)(5660300002)(186003)(66476007)(4326008)(8676002)(9786002)(6916009)(66556008)(9746002)(36756003)(107886003)(8936002)(2616005)(426003)(1076003)(26005)(86362001)(478600001)(2906002)(316002)(33656002)(38100700002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGhoVXpKSUh5Z2ZrSngxRmtuMFd5a0ZGVkpVNjg1ZXpXSnY2RHIvVUMybGxw?=
 =?utf-8?B?dUhPZEtjeExCL3d1QkpNZFFtV3UzVUtuOXJRaVM1OTBoQlErdmdqNUU0cHYz?=
 =?utf-8?B?WXZsQXlhektMY2VMUXhzTUlKZElZdTZvNTAzWGM1cWZnQmFZT3BSWXFKbzFO?=
 =?utf-8?B?MFlqd0huU3NrU1k2V1oyM0ZKTGNBbXlTYVV0OGg3eGhHeXUrcWhqYUVab3A2?=
 =?utf-8?B?VEI0U0hPaHlkMUdvUDRNcHA4RStJcUc3dVBlc0R4blp5cmk2Y29IeW9HL21n?=
 =?utf-8?B?bWs3UlNkSlE4WUdMZGxxUTF5Mm9xMXpmeDRkZ2dzRnhGdTI4S3dHV3JkeGhM?=
 =?utf-8?B?U0w2dXdQZ0YrMktnR21EdFRIVDBkdHltNW1xTVA1V2hwRmFXa2h6QzBPZXg3?=
 =?utf-8?B?WkVTWXRPNkRkdTd0OHZoTlZYOU9BNVNxbDFFdjBrV21jaklJMWEvaUhiT1Vq?=
 =?utf-8?B?ZVZGZjJRcEw4YkdqSG96TW0rK0d6YWZiZVhpSmp3dnNxQmhDNTlKWFgwTGFQ?=
 =?utf-8?B?YTNpWlVHd3ViQXFFQ1dvcXFZUWwzemt2c2FCYi9MYnp1b0ZVK082YzlsK3Q4?=
 =?utf-8?B?aFRHWlpGcnZZb0tyVkM5aUVRdkYyV2pSZWgycTd3M1FQaTlZMVgybUlBU0p5?=
 =?utf-8?B?cGJKU3ZpcEhoeE9NZnVWdnNXUllZVU9uSWl3NnBZWDlzTGljL1RtMGxOODh6?=
 =?utf-8?B?NVF5ZnJZZzVYTW1RT3BXSXloSzZ0dUR2RmQxRTBMaEVPdTB1aU9lTEF4RG9V?=
 =?utf-8?B?TVRZOE5yS1hwd0EvWHpod0x4bWV4cFFxZ1FnVm0zMnBVdDIvcGhqTFdpaEho?=
 =?utf-8?B?RDRCWTBReUt2K2FJeE8ybERvdkpUZGZrb1JUMjdLSmJScTdVVXRnWDhSOFRF?=
 =?utf-8?B?bCtoaUlKK2Z3cmgwTnpxOUk4OEJON1Q2T2xma2V5dGNabENZZlNNWkNsenor?=
 =?utf-8?B?Z3pkOW91SDNQN0lYY2hVWGM4QUhvL2RabXlZSHdXa0VXWjVYZ3B6VURiWlFv?=
 =?utf-8?B?Z3U3R05VSCtEWlFwY3NuajJ4TlJvcnY5QkM1RVhxK3pteWpCSGNsK2RiVGRu?=
 =?utf-8?B?enJjeDNnbW8zSHB1Y0EyV3dDTUV4WDZKT2dPb0U5MDJjSXVKMTQyemlFa3JF?=
 =?utf-8?B?bVFUeExiWExXRDRDZ3NjY0RtNEZ4cVBucEZSZ1NyR1VJSVpMdTFjSWFqT1ZB?=
 =?utf-8?B?ZVlVUS9hOGhYUWVjNmxScGNDa2NKaHVoSStoOGpacHZYVy9BeU9HbUVtTzh6?=
 =?utf-8?B?TzhFUXBDRmk2RmJPczFoUFNFVnFLN3VsT25DZ2hGNzUvWDd6b0FRN1NYYmp3?=
 =?utf-8?B?ZTdHazd4dlBYZkNueDBCYW4xRnF5QmFQU2dWUTJFeWRQbkNmb0tLQlBCUldx?=
 =?utf-8?B?NGJlOVJJNG5jandJMkNuSC93dUY1d2c1V2JHbmNxdTdkUFZtZnJ3VkV4Mjl1?=
 =?utf-8?B?MU1kYmI0SDRFa2ZlREJmb2x5Z3ZBMXlOU0JTUEp3cVlRM0FBQUJtRGJlRjAx?=
 =?utf-8?B?MHFrR1BnWkZTQ0Q4SHRKUnFzZlZqaUJ0RUhDSk9veUllSERnanJTaXoxNDF5?=
 =?utf-8?B?blJ6WU8va0FGYVpwdE0vNDhTWU93Tyt4cmdqbkhuU0x4RlFrQngwLzkrVURY?=
 =?utf-8?B?VlY1cFJyY1RXYk1wa2E1cTdHRVE0SkFkUkRjQ0EvTjQvYnRuRmhuallIVnVj?=
 =?utf-8?B?RlpCZmYxdVJaeWZ4Qm5VZUd2b3ZCMXJZM3M0K29HMmJMNDZsNExKMTNyYjhq?=
 =?utf-8?Q?biTCOSoRu3uQ0Yr6RyvkCRTDfrQsFjFMRP/IdWy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f58452-6a13-4e4a-85b2-08d908e68722
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 19:07:25.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E678MX9kYECj2aLW5sioVM2L44tq9rG1ReqmO5DukKKQcF2OoBVrzbcABdPkQ5s+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3020
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 04:20:11PM +0200, Christoph Hellwig wrote:
> > diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> > index 5a3873d1a275ae..0ccfeb3dda2455 100644
> > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > @@ -244,11 +244,20 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
> >  
> >  static DEVICE_ATTR_WO(remove);
> >  
> > -static const struct attribute *mdev_device_attrs[] = {
> > +static struct attribute *mdev_device_attrs[] = {
> 
> Why does this lose the const?

Due to the way the driver core sets up it structs:

drivers/vfio/mdev/mdev_sysfs.c:273:11: error: initialization of ‘struct attribute **’ from incompatible pointer type ‘const struct attribute **’ [-Werror=incompatible-pointer-types]
  273 |  .attrs = mdev_device_attrs,

struct attribute_group {
[..]
	struct attribute	**attrs;

Thanks,
Jason
 
