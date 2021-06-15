Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F282A3A8394
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhFOPHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 11:07:06 -0400
Received: from mail-bn8nam08on2044.outbound.protection.outlook.com ([40.107.100.44]:2663
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231401AbhFOPHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 11:07:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTiDO5RW48UkLL9Kn7R9FqJzmaHHISGEnfSCq6aPxYmZVczVGNtdCv0ccV+heKUK2xKJ3PjodjHoVQs+wigsFf0G9QtYAyYQ5V4GWRxkbKAk7fx0pUQxsQYyeokgPewwJJSznpZak4IuNk3x1mVOcLW6Uq9gUBqAn6yoNyNSI2xXRqNl30+Cpw4g1ykId6DnWLhXMrdARQWqlTBLTAc8onoo/PC4RQWiNrFyxwwoWIVA64OvuZETPtPHzGmdqz7BA7Vqhu9X8zDgiSlkNjkPzFmQXMLlBi3u0WbNy1r+CeS6x3vmgYy1tQB/SyX5Htb/T/EiZOj4oVhjXlEBMxADYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKvi9j+yYd04gvAzT7I9sOVgCQkuyhJ+/GeECYhT+VE=;
 b=Y0PYpDqpfDmg+Vr91ql7lA1q5sGbGJu8tD5fPN7sjUnVn0nyTM4LWcnJUITlp7iYOtrwzM2CMZ4reDJNi0Gw9fPbKwmOxhzAJjecL9DcpyVFNAJH4PFRr91w7RehHjweAJRKDnmPC9totSSd+QwbAdJ8vgsPOEfYHd6qWTsW08dt/iLMdrfa7Euu7+NndxSsB60/vPc4Tpc+qgR6xBt4/8deybcLkEGMwYSGSzI48qwXmKhbtfqyxWevTdsBUD3STobr+XPBxUItYWbtY8RKHV9p/kSxxmAUXWqe37yAdeHTiAz+Vpvpk2eW4zxqIBDn3nE2+sEIDCUYmqKR6fkQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKvi9j+yYd04gvAzT7I9sOVgCQkuyhJ+/GeECYhT+VE=;
 b=RMZtKXPf4eNfLKVKh6vpnyL0EQw1cVFInTGKEXb8twoDscdAENtKJ4Yx3745RL3726dCa39hGKIq1wTxQHxn9Y9taMhQx32TY4lgnBRstmZJO7YlAFQur5aCN4+KIRp9fTxmnYEI2xDtGB4mMS/3Z2++uehz8L77z1ezujXZTQ6iU9edjRWAneSLN4CV2cdVCHZO3j8GT7hfGx6fdLuSHw+kTdZGi+t07tvxETqcEY+h9mGF032+4GnpDXfm6lndM5epgstNJ+ndUixVacixMaRyEV9pMWFicFse9/1bXFtwQr+MQH2ziW3KFPxIrwTNgXg28Psd1E+Eo+F1L9HFyQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5096.namprd12.prod.outlook.com (2603:10b6:208:316::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Tue, 15 Jun
 2021 15:05:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.016; Tue, 15 Jun 2021
 15:04:59 +0000
Date:   Tue, 15 Jun 2021 12:04:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615150458.GR1002214@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <20210614124250.0d32537c.alex.williamson@redhat.com>
 <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
 <20210615090029.41849d7a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615090029.41849d7a.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR0102CA0041.prod.exchangelabs.com
 (2603:10b6:208:25::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR0102CA0041.prod.exchangelabs.com (2603:10b6:208:25::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 15:04:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltAcc-0079mu-6K; Tue, 15 Jun 2021 12:04:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b755cd7-d9fe-49de-2269-08d9300ef1a5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5096804BB9CE1B9EA8FF9752C2309@BL1PR12MB5096.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQS8H7+p9U+NZJ7atJ7iKPOfuiZKji4Mzu+5Vg/gT6ZFWiBtP/wjtvS6rPf9s/tiZ2+mGShQWI1kn/gT3rWBkT+VeAfHJ5NOdRLdSbl9fLIwzudu3I+/yLtSMah1WtRyaNrowqc5gopOoXw7xyRc5AxBCR0yIGV2fhj/6KMBz60GmIdTllB8QiWaAVdMrk9OpYkOfyxQqEg11gBVpjvJccRGro7hoVvHPLHTF7l06qtrmXbl+gufMRXfQpnJd2/tX8V/Tal5b8shLBsEpllOqmjnglcT+VVHOxouMNHwlZiWE/bULk1RShPjYVdYT8iVqwE6H9uwhieYIvx33Rt2Gwi2CNgwkyCFIXpVZ/MPlM8U1o8fg6G5toJVTQrBgoYS7yRIARC7EelHxn5jGycNkPo5ZVSDfFo4sbItPhMPlAE6qslAq/vBfLyfTuR9RrU7YAk0vaqgLQ5r7bTTsTBFw4HJ/tdApjqjLv9xvIaJYgLwkwxV7J4IKoL9xfykUdyyrBbxuZMRQK0O/9VswbBS0ZDk3LMM9+XFcy8xCNydfYmBLFIg0Lh1Sze9suy5Z51po7XDE5s4OvvpbvLErtdCvYsL6uhTJN+zuAZS5sK43CM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(33656002)(66476007)(66556008)(6916009)(8936002)(2906002)(86362001)(8676002)(38100700002)(478600001)(186003)(4326008)(426003)(4744005)(5660300002)(9746002)(26005)(316002)(1076003)(36756003)(66946007)(9786002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UPbDbIqpZ3ZjItBAfLLwZHILwI6xYVAke5ytEQw1/uuXph+UeejN+gzjGWYZ?=
 =?us-ascii?Q?ZB2aZ3Jk5JA0pQlqRB51XcujxjZfzxZQboBnc/Y2Kkfols8JyKG/L04HFO0W?=
 =?us-ascii?Q?gJCYCaMzs81JaHnKyVFm/lFPhwjtK5YlhpRja8YIStWQGyFsBAqUVl2J2fJc?=
 =?us-ascii?Q?UM/56LVPHx7bok7ZIpkAxzh05BoJ8Nmkqh3755/j/m/jlKhCrRpIDfF0WPGN?=
 =?us-ascii?Q?6ywhKh9IYsV4YzGeyS4/96Fzv1RpB6Ed+vZUKVYtd8hvSm+sYLA0uZrDcnbw?=
 =?us-ascii?Q?wkYCAe28MaqEMwhjGcDf48kCblj0HdB8wIbhyUGEaNv7ALKnuP6GgfbDUMmr?=
 =?us-ascii?Q?EAfm50NkTS66VPZtg/eQNK3on6+6HDQpaFwTqdWW3wU8uLfddNeYxzcj7WG8?=
 =?us-ascii?Q?49ZyVlANjKG9JK+dpi/9ikT4w2IOJYufWhfWHMcic4VZa/YA2C+0wO/wlIBg?=
 =?us-ascii?Q?FFZOOLcx+cMekadH+fe61yYqXSoVXZwc2ZldMBuvnrPOXh3MRZDBrrOD/4mA?=
 =?us-ascii?Q?02iOPMx0SbLWdssufMa5o2z8Ep2ycY80wUgORjm5pKEfK8hwN6pN3Y2f6qfi?=
 =?us-ascii?Q?7C9LEfsy9nJIYClS06JGbuZjRVW/37HXhvwdMqFgoDECW/Pa4gVF+lvyCUs1?=
 =?us-ascii?Q?1wGo0QS6lj+aqcrWXUqMBID9lauQ08tdQz8c94lWnyKdbxPpXIhjuGs223Em?=
 =?us-ascii?Q?vwImUUUO49kDudxajZ0krM1+fT1UBT4OhRItSzQ7B0bKvqmdo6z5gDTsOd2p?=
 =?us-ascii?Q?fOB4pPFk4iyJmzZOBatomNJ3GpEnafTteDalQCIaXJxmqjSunGaJqwIqMFQQ?=
 =?us-ascii?Q?hYXuKnzj2rL0U+lYllxpZX1iwHKG0mbGVaGZdEbd9C1TYo9e2/4dQ7CD3i7Q?=
 =?us-ascii?Q?nDR4UqHAMybEAXO4vPrhrZ7uLA0UwD0vofup+bxCQIdDYG2IM0RWQoZ53tbr?=
 =?us-ascii?Q?ack3towKAIozBsJ8avxofjNsCuOU/LiWClr5ha+g35PWijw0mCO/9rF8E42T?=
 =?us-ascii?Q?ds6iHwMTjTsa86TdU+g2X9e7+wj2oZfbkjHdX7L5pp96H8ySw39ZEXmuAKKW?=
 =?us-ascii?Q?B5fPwZfjvieaKIKJbUwrRzutHyCDgDGipMBZRAJWwHRQQSBlI/mreH1iHFuU?=
 =?us-ascii?Q?vVPTG/mbehjfUroQc4bcgwq2vWpU5FqPaEt9FXGSovptYsy0LwL7FwwJt34y?=
 =?us-ascii?Q?E93HxI2wPy2efsRFVyThzpWFulPXJ65lrwy5MCEkYCyKHiJ8N4h+lYxTDFMh?=
 =?us-ascii?Q?7ImB/g2WJS8Evnhw2PLEl7yX+llpxX/oS6rKCIV+vNvjxrrdbgQCKr6xWXSM?=
 =?us-ascii?Q?9Ri5RGa/TeLqONi451l+x8vQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b755cd7-d9fe-49de-2269-08d9300ef1a5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 15:04:59.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idxOaqHMok280XPv1e9DkwzvnDmJs/IdQkKUFs6i6tGmn919e1LwSNpB39jAuP5O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 09:00:29AM -0600, Alex Williamson wrote:

> "vfio" override in PCI-core plays out for other override types.  Also I
> don't think dynamic IDs should be handled uniquely, new_id_store()
> should gain support for flags and userspace should be able to add new
> dynamic ID with override-only matches to the table.  Thanks,

Why? Once all the enforcement is stripped out the only purpose of the
new flag is to signal a different prepration of modules.alias - which
won't happen for the new_id path anyhow

Jason
