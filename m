Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352037AB20E
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjIVMXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjIVMXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:23:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9E9C2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:23:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbxOEBkrOyrslAzWIrTii6K4m/F/5nFSZQkpmu4j/L9jKvSVsMENh+g7nvEruUcZCioRcHFtZthECtCozH+Tbquc23Z+K7cG3LfZcZae9b6A8KK3g4Ey6HJC8xG86AWgUq33Ml2mAL9dEWBdnpUSvFboF+A7fRF7oHYOxr0ieoW/eutfnc1fA5vG2CsXpiKKmq4HE4ed4BxH52K0L4eEBgiwlZzQrF+HnxOKIzHeE5LoI134zLpAlx0LqE34YIod09cAzVsl2qgbkyUkLPxrZbohMUJZ+jAbM/OWlPcR2K/jaxYpNA8FBtM37eAcIBt1jkZrmlLiilfwlnBTHXlemA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8Oni5qPqWYlBzJGc5SZ2IrLZV6Qa6qmHqegZQSd/dQ=;
 b=jLKNGQULx/4OCrN0G87Rkqt3O7TBimywmDKHwYNcVILXNcPnG/2oJmomLcsIAmgKGzF2Gfb9M7nPkq7IkdTZLkTgVUDH9hf2/Qqnadpq21uhuhdTMeykJJ/LfoJgglsPoGmOJ7D7q36rq0H3P4FcE/G2curCvQp+V+x8CWjkCws82kS58kHSuiIhuHRHiwKGParsOeK0mkRZ7BjlCF3nBoRx5Fdv3tDN+cyqpWqlu/Yfa7b0QGjdIWGjmPi0q06+aJ3sPRytNokwq0TrXBNZPjvBkOGznpDNDBnTjbQynTfdMvhdsnQjSc2C/atUlmTneaR6OQRWd2HWQqhGbFR4Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8Oni5qPqWYlBzJGc5SZ2IrLZV6Qa6qmHqegZQSd/dQ=;
 b=cNISJo4nZgwe/JNhAhNmQb94pUPIXizgv4+L4gnB/7yY0LuvgIMzIivukmeZLKqyeVPR68t8zmZ++E9Wj5Hm3QIP7DE0cBuSiLgpLS4bxnmDaJLe+wbmjh5Ty0lYRYZZBqEK+I9Kr+wV3Ndj5LzGq4JekiuL1oWGq4xW4H+Ylbo9oU0mJHGizO1OmzkixyGKjQJMfklGh3YKCvkJIva6FT+ZTEANBcx98AqvGxiFLjjjNh0OW/WJhAMS1E6WmP6t1dfJ8HRx/94fzYqxjh/BqxXAy+G7SX/2yFObCm3WfIrio1wfdwid7pY0QwIBUtB5DITU8VaNIdvVygPFLPm2vQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB8130.namprd12.prod.outlook.com (2603:10b6:806:32e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 22 Sep
 2023 12:23:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 12:23:29 +0000
Date:   Fri, 22 Sep 2023 09:23:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922122328.GO13733@nvidia.com>
References: <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <20230921224836.GD13733@nvidia.com>
 <20230922011918-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922011918-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR14CA0012.namprd14.prod.outlook.com
 (2603:10b6:208:23e::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB8130:EE_
X-MS-Office365-Filtering-Correlation-Id: e52510e7-fcb0-430e-0918-08dbbb66bac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /RILuksm9Zlw5okc0zFD5b28iJXJJJquylavu9VIU8Ve4PkA+dXTYPR7JAIeO0I4rYyKbumvlpm3Xv+ZYBolunZhUzR0R9HEoubAtLJw0e0K6cBKJTlnMBg9AApUzeEtb85zxQJGuYkXsxBnGS3wpPgEMaQJgNzp9lRoLTfpaX1kxwsfU9Z9lMKmPRFoIc1eFtEOCK/Cd3TAZZh9AHVZS89s+cYHaD6b+psll0VbDAYEskErUHo1uaatdMS2KYfO5hVp+SssvPiNNJ7l/MehI7zHCac7GnL4UZg8cVsEWIBMBpbrmECkvFiWdsDinxILxergqU1CHl2ElfPDdZFjJ+IC+rDGZoBWhIzbTik3VLuldaJTDETK76+TfeIcp0P03qJ5wbSzqegnLEQ0CSDjCSwnpvWhXeOyBunvY7OJOTICd+hhftHtHYPDDr0mc08SeH0Uk+U6b5H/UpL5kl61uY6zVU1q2qtZuT75XJGEJ2b577mwVVhpFiPX9VzM5DT9rf1oBydYYK5dqN1oEKHtofMJKX+OMnUt/scWfYDWRBdl6ntmQC4PFCDRSYN4YrXq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(1800799009)(451199024)(186009)(2906002)(4744005)(4326008)(5660300002)(8936002)(8676002)(107886003)(41300700001)(1076003)(316002)(66476007)(6916009)(54906003)(6486002)(6506007)(478600001)(66556008)(26005)(6512007)(38100700002)(33656002)(86362001)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?un5/TC67cdIxmr5BLmwYE7jxv+doSTTxNrgkH+Q1ssSN3XSs/JzrxdzlvGdI?=
 =?us-ascii?Q?ytJwI4Mi7ADHZmsyFJklsMmuuMC1an4wJQr1ghoz6/30NuREQC+5PuvPG5C7?=
 =?us-ascii?Q?XPkZ22QkM/LJCT8GiiDOb/raA4Tc6AvYdy9QtogPdd88FyO53SnCBbdwr1wy?=
 =?us-ascii?Q?OWyVJFJKFpVBM1QlE45jg66mohYx3Ke38BoqhQrhPrs4VZo+F7Scei7MZebD?=
 =?us-ascii?Q?wWoV/KzekFIb5eT73Nv1gvd0hO+3I2l/GYW7zvhUOlTl9HFWZS3fOn+HWBd6?=
 =?us-ascii?Q?NVbR7JKfu7c7h7siwH/M7BCj2S32UxujjhlaOD9XyrDRc6vqiEuHFhzX/XFP?=
 =?us-ascii?Q?gDYOKskHqg9Eo735JO/Sv/8EjPkvg3Ei64GKa0joFU7dlgSFhBB8xKwNUpJ0?=
 =?us-ascii?Q?xulwftonHeq+Ji+uncyrEemehu4CD1/yOneJXdJvTDTUT6fvpHOYcMMQZehB?=
 =?us-ascii?Q?5P67xm169vt5IUCsXJSksk6MpmhwX/urj/yDtcLfyS74ipQHv3wwduqkKM/c?=
 =?us-ascii?Q?3g/6wpufYTSKvKpLAb+uL8s9G4RPh5TsdqKeG3yIXC14lzW2ytJANCGeN0PD?=
 =?us-ascii?Q?OKSXn2lWdG2uoTeESv8KWzRlEo43QCnIl71FIIVyAkQb9xstW277vUopPH1O?=
 =?us-ascii?Q?kQ+4vp9iWJsxA7fGsv/Il1yjlaQxYizajXQOnD7VOmMUcl5L7P2c9IDMYb0h?=
 =?us-ascii?Q?GLKGh1Ct0zTRR++VH3ME1Z8Qfs7pDzfXdUbw4IJ8A6udglR4STgN2NM/2K13?=
 =?us-ascii?Q?WOd2qOFCRIQZd58qM682KecYCsQiB+TurjAyPqMw1a23oRjgtK86Yb5FfJ+b?=
 =?us-ascii?Q?PQyNjWxgmzugGCXdAdjGYs6Gvy7J442HNvRIjb8Of8Q0RNA4lEGNVsWc2WM2?=
 =?us-ascii?Q?qaY5m5UqZGd6F7j2UmyH9XmINt1+u/+A52JjwtOYau2G6O3WKbDGFgf+lfuf?=
 =?us-ascii?Q?aPFm+/2wNKnDSIgpzOTQdurq6P8lxzbxzBCnIaFfOuUxuuOfcPkUa3k23DnQ?=
 =?us-ascii?Q?h0mWVSOawlhgs7S7evoq/ilimGf4JqaNblC8CvBEPaGZ65v7ex7jBRx25sbU?=
 =?us-ascii?Q?3udB77jLfW2iTD43xjHp2Il2w6ntEmr/fdKiBp9Xb4xmQH5BVfuqcXthFns8?=
 =?us-ascii?Q?RYAI7CAfTGDd4MFGuk7JqpoW608gts+WPBD5ZWlEuOaXMHHbEgDFwsVfPxzi?=
 =?us-ascii?Q?LDNGU6JFY7AefQMKrbs3uI6pJC5T4xzSW4wuLko1/2HvB/oJ2kiTxKqEhE2R?=
 =?us-ascii?Q?/fv/KAYe5PM696PckoLcJTWcSAJ3n+0C7il4IcCkg0FlAfSj80QiwyOmFaCz?=
 =?us-ascii?Q?0otefuhgSD1XkW7Yh0GyFaKMlwdjgjbVhs7C0JonMDHKvgfhN9sJtX+92VRw?=
 =?us-ascii?Q?W0FwYY+851w8HmD9wUy/e6vcwwf3ZD9du/yL/987OewgyXOnlC0cSYErP3md?=
 =?us-ascii?Q?WSYslxPRHo7J3RWYrkh5lLL2kdfWDQMsXT4vtV/eujKP2rJnN2XVnPe/l8vk?=
 =?us-ascii?Q?muggRwLTGYk0zhadueG3DeI51ETQ4ACsm/eo8fyoaUC5gjMYwQMFsjM+R+tw?=
 =?us-ascii?Q?ulQxpeXl2BA5CQGZD+DjI4P5rWmK0mhm6+9Z9e/j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52510e7-fcb0-430e-0918-08dbbb66bac3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 12:23:29.8653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7pSpM0fxnlvZr1jNaUHAIAlD9mDXce4k2tZqeqBMtGMGbmI26mQ5kr6TgtL/hnq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 05:47:23AM -0400, Michael S. Tsirkin wrote:

> it will require maintainance effort when virtio changes are made.  For
> example it pokes at the device state - I don't see specific races right
> now but in the past we did e.g. reset the device to recover from errors
> and we might start doing it again.
> 
> If more of the logic is under virtio directory where we'll remember
> to keep it in loop, and will be able to reuse it from vdpa
> down the road, I would be more sympathetic.

This is inevitable, the VFIO live migration driver will need all this
infrastructure too.

Jason
 
