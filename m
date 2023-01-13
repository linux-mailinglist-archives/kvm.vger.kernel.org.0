Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34B7669B40
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjAMPAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjAMO7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 09:59:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADE472797;
        Fri, 13 Jan 2023 06:50:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PR4FikugF4holigJwFhQfYa39c1faTpK86g/mZ9GOwUxJ/ztsJL+kP9P5XrbY2wW4lsPKp/wj4VfLIcFIk//KfwW3P8QGedJWGnVKR9nuEL/+CGdBzEpiSTW2/hkBglWKoJMOqUXsUUC9dNBMy5Z+ZgRWVhODoidIRMCjctIEo+7iZt1MLV0d6Z5u1NKyYRpdxFZep56sQPnZsGlxMjuGKagy7kh0V8g10Qlvu9f/M1N1yhWRCpqVIAl8TVxWapt8X3WKllhKVObpvIhkCjr6Z895Cyh8loJyzXMbCoM56os1EoQBVYm3WOw6WccwFa/eohZ09JwwsE2etR8X/wGig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yxxf816EJv7FxyOgGwLix7zF2lcdpj6h/ed2O+GrU1Y=;
 b=VwMuUWPf4GBaq0LC7Gqzv6HUGgYygjUcG1WNP45X4eexwaoOlHNE0P/bU9GSOQHTwQSHY4EWUlaMlmGH/X0B5EQx4qvfLN20eIejW4FvonWDxyLYBNfFm/hKhoLFX9pDZnStk7rgMtOAOS/JWlUrFkI70QMOQ8OeRDYn1dHwLlasF22fR8Y54yvdkw2tid2k7wyeC4IW89xj+jJyPH7+gbbdEFv5w3iS1G/vcWE35t+DPuFl4m52IiyYt6LftvegaPuz7xQHSvB+hBgZQdCiqMrRTUfQVBlKzhLcqeKnBVEbbsLcIBNQMEbPF45ek+NR+vR3Nj2pXn1f1bUqF6wxTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yxxf816EJv7FxyOgGwLix7zF2lcdpj6h/ed2O+GrU1Y=;
 b=KVV5lznnKE6aO7lnmHnArxs/xVVuHsOoEqNv7Q5uHw3TuqMkJUzhz3sX7qvj6iWU7W4OZ+55iPRs/Uub5pXBOYGcsv097deere0UI868URzp7STmkQSJNtPr3Sh96yNxY9m/P3sdP4Dt4WR1tzXJEd2M42kHMQe3KwMQ3Dc9OFryKWTgNFXjGkLJPZCPExFCzKmyKL+WUhXxEtaFJdfaLt9SiFwwkYmgzwfboHWqjHwkwRi9gTeiS3DoPtxoeIERyxwTLjz91N1RPeppkOIx8wDDz/VZ1T4aZDEr1QMoFJyAQdc8B9XH8gefLCOhOPYki8daWjEmMr1w0/OCdUEtAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5182.namprd12.prod.outlook.com (2603:10b6:5:395::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 14:50:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 13 Jan 2023
 14:50:30 +0000
Date:   Fri, 13 Jan 2023 10:50:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, pbonzini@redhat.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8FvtS3uOFUnSxss@nvidia.com>
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
 <20230112140517.6db5b346.alex.williamson@redhat.com>
 <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
X-ClientProxiedBy: MN2PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:208:134::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5182:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d357c83-bc9a-4a5e-6bf0-08daf57583f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFHFuothd0pY4AeqjEe8viHtvlUbs3vamZRPnjqVXjLVzB3P7fZwxLnbKIBWfjTeY3xa23mWin3ekc1bGyR0mRrW5mukOrXZ1MKtYHptDs6k4rlWr3Xjt2m+FtF5dJEr+IUn4VEOT/Wf2JixCZBRLY4CVgRNyFYhX0ZDeLe0/VRAG+l4LzKv9GOQ1EEY7eBAl0m8CO9kY8Hhcp0a4pH+CufYJ8b7GRlt9+ssvb6XRP5WkmSkQjs2OAIsEeZGSSDzIsgizbozkb1YS1nBXvrI1yt1EcxypWhxk4lomgOhjr+5g2EIrBXa/EuqDjlro6GB7ix4iLtiqRX7IfNedcdymuK4ZKtPcgxiRBDuqINsPTd0yOq9PzsLpsKg6H/uGCNDZHDoEHJ1MWktXzYDlPMWTFaoVrEJq//M9prlhS7aQvTlu/TEF356J90i69M/nx+Qzv5zdFDjz0eMwoInJztpG0JmOGFCwS6h1VEbQz8xUE2ONc3iFn5p6at0lSxgTRPDr34vPwi92yWpgV6/05pImMwnAF9zbPWmndORSEPAPT3/qfitIxMusNDB5Sryxdycf5vXYFJQ0Qaf+w/UoVpgpWdCfLoY65x2zufmkQDojwyHjqfNgdZ5bYAfB9mcr9ns+cwMt2WMu69wk+QbGKveVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(6506007)(26005)(186003)(6512007)(36756003)(6486002)(478600001)(38100700002)(86362001)(83380400001)(2616005)(4744005)(7416002)(8936002)(5660300002)(2906002)(66556008)(66476007)(66946007)(8676002)(6916009)(4326008)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RRPzaDZxWKNrHJfnTnqPLlDOGXyovR/CE8iztf15z4MTROsm44AEwuMiGZ6w?=
 =?us-ascii?Q?K1PWQCcbFB5Xw7jRgyWaGYqNkiftLwBOgfrPeAfumCbYy/ZMC9GENyekIAIP?=
 =?us-ascii?Q?Ub27CL+tDse5oJyCTAUUNnTED6SiCYyKF8PYuUYr+qvJxu9rk2M/0XHLn6Hp?=
 =?us-ascii?Q?K4RaA1/iFPJFkpxZoqcvyMeoYNdmW1i3tMQm2tQZHSyAPMrPaw7o0hFw5pU+?=
 =?us-ascii?Q?9kOYc1Klsa5gdfzVHu8/cRLyotaVhrGGWztXso/Sp0THj4Yp0wVGHz6lZnbW?=
 =?us-ascii?Q?zmkPmEvwiKDCbUsK4IYJ+vxuHwpa01Gw/3apTIEYPvLUZVyoLr98ldJNYBEy?=
 =?us-ascii?Q?erq5OVDH4ov6Sl2mqv8Am8B4e47/xAXJXd1X1kDrLkj209bCzvXJ+Y4vFPLM?=
 =?us-ascii?Q?A07LdyfIFrV250+QrYKdwyD/qZCqXhC4xYI8dFi6VUgHTJgaVBHr7i/CnNQ7?=
 =?us-ascii?Q?yZnxjYevaZLwUp7+zWamAmgTqfraXjK0ROC+qMsBhy6aFlFrtXxciWaxZeMa?=
 =?us-ascii?Q?bCAIiK8q8l6qMUEr9ox8+eO4YM8p3RwGCf2twNVHz6i7FsJFXFaipx+MPu0J?=
 =?us-ascii?Q?wHjb1idtACsbndV5Qbh6bCc6JXYEVzM5OWjSbYgEoHMshjSQ1wCuLCdmXZvO?=
 =?us-ascii?Q?SmHqhNMCSEbaPJFMqCsl/L+odfJO3VMuL1EaRUxQ6RnnCzNY9W74Mm56zVbq?=
 =?us-ascii?Q?v3rTQQ3FA2XbApSZAkdN2GnH1k/7ylkxKefc4r6toutoZdZhy/SUQVNUB9bb?=
 =?us-ascii?Q?ReEfTky6crGCA6d+egJeoBV+/4eKHzsodSodtmtgjKZUdGyQfBtzyDFpkzaP?=
 =?us-ascii?Q?rkKWWe4CvOWWRy0yQ24DNyKyf7FbT2azkCaafH1PaZoZKQlsk/3QGEquei8z?=
 =?us-ascii?Q?p4lvu3r39CZMue4W+jZpEo22rOHjqFzWsvrkoDeUo2IwR6vu4l+KZG7HwzGi?=
 =?us-ascii?Q?LlWIXIKBRJ50KkmFsGGKStYhAxy356nPIK8BaqpaABmxmIdUP5HeSAZjxTiD?=
 =?us-ascii?Q?qwD4FhWAb2vbfi54qyfaQbq1xtMVZbZDo/vEm+V4rqdNRNvbxVv8hPe4Sw6V?=
 =?us-ascii?Q?y0HeGYu1tksMer6lelQQC0LIh7ygjjm2WePjtUxsLOfjy1QKTyM/wYQ441l3?=
 =?us-ascii?Q?xC59pId/O62XDesSNVc00RWI8cVTVv0IDSZ8f6PpOVvl+Sp2DWA3XRSbg8cA?=
 =?us-ascii?Q?pH5Z7XGV5rJTCR7XWY1SbvG9SFWZfJ+lDMOz47FuLFLVYZjpIXv4e5SxroAC?=
 =?us-ascii?Q?HPl8Jn4vD44l7IxrH0xW8QUGfu58N1+GHZ4BtJ524nWW+NOCbnYXRBohfj0v?=
 =?us-ascii?Q?cblqd9h/0KEJMfTRYv2a2Stoyo0e+mWlUyeuWMfeG1KJ1fGOX/M58lyABXE9?=
 =?us-ascii?Q?xyVmlf13YXbk4Xsm6CY9nW+bC/tk2Xli1V4ZshD/fbkypjST0pl+/PPOQXn1?=
 =?us-ascii?Q?aYKLnm/4zNa7GritTSxk4mvHZHvwOMP5e3kfrX0Zb+xQNFQvytTPsvwfcpzu?=
 =?us-ascii?Q?wDZJ2efNMPuT5iBz0kuIRPI7thhaKLo5c9b3bWzD0KS8zpoSraAHT1MQ2VhF?=
 =?us-ascii?Q?9EYBbdBT2b3tgYv2s3AQ4ey+QkUZZMdZcwXiMYyA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d357c83-bc9a-4a5e-6bf0-08daf57583f7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 14:50:30.2386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boyu7JErkwvBrol5k3J9FQKmQL5uo0f88whPAc+9JWS59911aIrC5rnnPzxUwPtO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5182
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 04:51:36PM -0500, Matthew Rosato wrote:

> Yep, thanks.  I will surround this bit of code with
> 
> mutex_lock(&device->dev_set->lock);
> ..
> mutex_unlock(&device->dev_set->lock);

Don't do it like that, copy the kvm out of the struct device to the
stack and NULL it. Then do the put without holding any locks.

Jason
