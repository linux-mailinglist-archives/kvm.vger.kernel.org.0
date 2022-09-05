Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CBC5AC9A9
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 06:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiIEEyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 00:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIEEyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 00:54:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE7617E0B;
        Sun,  4 Sep 2022 21:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBP8xjC5UHv0eiuI3lsmMohu+Rhni5dGVi3OOyMQJld1PDYFJpkBALiVetxw8uB9KrUvNiCrutFqUASMPc8qvyiUzkv0Sy2h8edP3aCI5xVpgLUzCqEKkhIEKgwOjTPvic6W5Y6EnzeskZJ+6Qee2zBOd416bm0o7K/bbk8pMlsWn7eUibNga2ULryH7UzqRY3ZWSQbdr4XTwtSmtoZfuv2InUvTFfHDUK6JydCL8WFcDypBHgiSOil1m+foABsO0Hul+7MXANOleX5a9OAXeDD8vMvjmy0bjsrIT2JUV/+sEjPU2cx6ekvqff2HH/e3og0bt5U55UXj28dAq7wZtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VApS/yBW941D/daKAn4pW4AvTu593l3xugGJ3jWM/TU=;
 b=iVj8tEK1LrjOuetpWyfvfonuOAr1UGuhnGnc5XSsZQVm2VczuEXvgms6+XIP0HC9oEHwYlAnfBYCAwVDUWSRFgnGOi+3nH3mSexnDhbS0Qzea60GA9tBu9MA/aTTvdF7qwxiMy1s1ZAasOpVD6Aj8DYn19MumNBubuwr71FTmz+6zd1H0rySJEWbofSnawl3bapg6qqGmDA57h4z+18xFbRf1A2tdIHPnhKex5GKESwLzdtE7qM1MGTWr3qlkbrKM0wohbgV58LEmvUlp1Dc7ObBuqh/q1tjuiLswxvRI5MuxEuZEPdw9eyR3G+KoCW6t0mx+qQzALmr7WoE5GZKQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VApS/yBW941D/daKAn4pW4AvTu593l3xugGJ3jWM/TU=;
 b=BnSkxzT+M+fmvQBq2iLEULVrBcgdurq9L7JgZFkDXUFjy5gGlHb/h/coW1bfD18jHLxFpoHL6NR/n6rA7yyOaeKnCFjgLp99jOq7Pb5Xi2VfKmCwjIYkfA+rqYdAJrnKk37V5818eslR9P+EE5HJGqYcBC9Gro3CQAUahfZamwxp6fQ7T3/2N4M3sWdGQd+d/Y9rmk9lU7oQSVXbprory3lgDway96k3KmyyZTDNVozZbXl5TcnWnl4U0cEeEbkE1RYJdgghuuqJV3WqgdJblCNzwH3swfUXgQt1HzDQxVfjvGKvLqHwWc5T7c2T9MiJEs2cKLhZ1/1+cSoeC40zDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by IA1PR12MB6554.namprd12.prod.outlook.com (2603:10b6:208:3a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 04:54:49 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::753c:8885:3057:b0a1]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::753c:8885:3057:b0a1%3]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 04:54:49 +0000
Message-ID: <75332807-3645-6b82-be49-448ed8313a84@nvidia.com>
Date:   Mon, 5 Sep 2022 10:24:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v7 0/5] vfio/pci: power management changes
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220829114850.4341-1-abhsahu@nvidia.com>
 <20220902124234.472737cd.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220902124234.472737cd.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0027.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::20) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db501967-196f-4dd1-ae14-08da8efac314
X-MS-TrafficTypeDiagnostic: IA1PR12MB6554:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+Xt+Vd2GFcumhZhLgnLTwbzMnX+CcihAirzWZvI22PUaPYxTqCYFfFH9wk0mzQ+z4lylLnJnSzoU+X6XM2b+/1UIPEJTeGK7NRedoc3htdK8E4njiKpq7ViaUSc80GSQuYt8ljSLZPdNFcS6a6SRZyh2phHl01zs0W8ydtiYkQd1uw+iiBiriGNbrMBlgzOef4KpeduwmgOXjLreAY46kCiD9D0qHqIrMufPF+N0Unambe0LnkciM9IJCpJPYt9nVF1Xpm/frvkba8D5MpSSOguYrIZ+yHsNSe1NH+9caN2kjbXRLhiW/scZe5UHiBMjIwFnHMvXuNKglqy0jQKbWMGqmmcq6HEAr3uNG7of20Ldzo9lfNWKKfubnczvAyHk4Icx1Z+P3SfYpDnLfZSwf7mI8feAdQhTEdC3GUmlbRqVRBmK1e2yiDOUOUa95pMvRLXPgKMs7GByZ3tVhaYj9kBpSBnU7Cq/ny3P+x4222/T401wmREZ1OY8bA1+IJEzPBUzaq0U3aFAjjh3cPX41yp51TPfdu7EZXsleW6VebWlxfB8Fn0xwIUw8900lJqJc1sT85q5DYebmQLWDjuK2MJwGI8H84CK/J7mhTXYwQqBcToVRlGw4fXrmDUAGWeR6qbKOduQt7AIl6uXxkZM5AsX8f293XjTxhyoKJzmYxDuMAYA4zBoXUBz+7PT2OuxwwXeC4hf4Ohcnd0c/414tW7WN0OVMgI35SVHs7s6zxCb8IQvXuxrlnuydiLc1nUZcIHrogDQMNF+hIr0j+lpXGcjG50qdA4UV+dKx3aS/u9cPES01Sq/cw4of2UAO4qLY6bIibdm/GLz6EgBSHVyLCCXpzqRxtUJDOKgSGFNZra4Lw4Q0T0Hs1WO5rWRUKq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(6512007)(8936002)(186003)(2616005)(6506007)(966005)(7416002)(26005)(5660300002)(55236004)(53546011)(31686004)(36756003)(6486002)(41300700001)(86362001)(6666004)(478600001)(54906003)(31696002)(83380400001)(2906002)(6916009)(316002)(38100700002)(66476007)(8676002)(66556008)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eldhY0pkQ0lIYWlKRXd6OS9MR1c5a1o4eEFGdWM2Tk1PSWFiN1NDZHFHVGth?=
 =?utf-8?B?UWs1a0J4Wm1ZdXJGVlJiQ3E0UFJ2K0QwSEU2MmExYm1hMEE5N0RnVlZoQzI2?=
 =?utf-8?B?ZDFqWG5ySG1lVk1aN3lZNi9tdEwvZGJ4ZWlqeDdQMVB3N3hpT1pnNjNsdUxD?=
 =?utf-8?B?NXhId1ZsK1lLWkJiL251NFBwZzFOYlJBM01sbXo2RmlNWGkrYURFc29IWHY3?=
 =?utf-8?B?Mzg0NHl0dXI2YzdjM09BbzEzS2E0TnBROEhtWnh0ZlZTZGlRN3E0S3RDbHFP?=
 =?utf-8?B?WWxOaDNJU3pQRkdEd0xhVm9OTzlORGRhMmNEOWxJSlA4Y1Y5SXlyQ2dEQk0v?=
 =?utf-8?B?cjJITDRkMjc2YUF6THlnSXo5ekpmMC95b21jSkRhcEU0dTQ0QnkydXppcUJG?=
 =?utf-8?B?UEpRNnB3MWh4MW1SSy9lQ1FUN1pyRUk5NHhGQXdkZnczVEN6NUZrNmMvSnpl?=
 =?utf-8?B?dnlEaUkzOWwzQWIydkYwQnJ2L2F6aGRaR2FMRk9ORHY2R0NvUFF5bitER3Mw?=
 =?utf-8?B?dDdDWkpuNVRERnJzREtlUDBTNEdpOFpYdlFxSHJjcjNqVW9PVUlnS21yN0VR?=
 =?utf-8?B?UXBPWlBJWUZ1cTZCWXZhL0kyRXRUZ3Y5MWxCZzVpNkp6RVZUbis0blB2NmZ3?=
 =?utf-8?B?N0I4RWNJZkx4VVdrWEw1Q3YzYUhJVkJrYzM0YzhzZFE0NHlCakk4OXByaU5Z?=
 =?utf-8?B?Y0N3M1VFWkdaVFZkRlRDOUZ0UGthM05neVJWckl4dzhBV2J2RXNWQlRCTyta?=
 =?utf-8?B?RGJJcC9jbmE1dkovd0ZnWmtXVytDQ2E3SCtaaGJ3K2VrdGNmbDU1UDJjK3ZX?=
 =?utf-8?B?ZjNXdlB0bXZQaVlxRFA0UFN1WXIvUllvcnhtRXJNVG5WaUtRL2J4a3kxNTJh?=
 =?utf-8?B?ZnBDTWxBaGZXckFoWjIxamhneW5kdnRsTElkQXNHbjRBNUI5MzJEdXpjZXVR?=
 =?utf-8?B?QU0wUWUvWnl0b0YvOVNpa3d0TUVsNVo4NC9nSkZ5V3k3QTV2SkgyQkQ0bUhw?=
 =?utf-8?B?VWMwN1F4V1d2SVdJYXNrL1dPc2tJTkNmUGJHVi8rNlNCekROSFVTUnlmQW1O?=
 =?utf-8?B?aXJmM3Q0YUNUWGRXVWYzeDVQMlZSanFMYk1VRDhQenNRRTEwVGJ2MGV1ejVw?=
 =?utf-8?B?SnptRzl2SXA5QStoa0VzMVdHUU9EOTVSN3pnZWU5VXlsUS9ScHNqVE5CU1VK?=
 =?utf-8?B?ZUJCd3VEWmdOMkwvbHpJTVhhOFRYSXlPeTUvc1cvcmduN1VFLzBJbTBqTjMy?=
 =?utf-8?B?OWVzaVNjRU9xVGpBelAvSTJHSmpjclJGbzRBUDRBWHV3aS9CT3F4SlE3YkE5?=
 =?utf-8?B?NCtBaURMVzZxMzcwamxXZ1VHUGp3SVNIeFFlRHREZU51eFVQWDJNeitLRDV3?=
 =?utf-8?B?V2pEQmh6Y3dWa2laeWllZC9YeldIbDlHaERGYkUwa2xjd1VyZjVjRnpZWnZP?=
 =?utf-8?B?dEQ3UjJqLzRJdEwvT2plVkhXbDR3TUFNSStXSGloTDdqNnI4ZWR0U2E2K25K?=
 =?utf-8?B?ZFU0TWpNbXExcXJKcE9vQk1xREVVSWNTbjBEaGNzV0VxTjUrNHRaeEtDRXd2?=
 =?utf-8?B?aE8zOWlZald0c1M0NEM2aDA5K3pIMlVVUm9JTjhhOGVlb2JCNnh4Sk42RnA4?=
 =?utf-8?B?WUVLeUxiMHY0QnFqY2NXSHIzU0ZCWjhLSE1hZHhUelFRTm5GK2J1aUtOYllj?=
 =?utf-8?B?T0hvZXlVSUlDKzF5RitGUzNIdlVXbWRpREQwdGljTHFqQXhHTWJHTUpGSXhr?=
 =?utf-8?B?QSt2QklaY20ySTBqb0pTV01JejgwOXJNbVUzRzRkSWRCSGhHeDZ5Zy93blVR?=
 =?utf-8?B?SnJxSGVEQlEvRWZCbGhzODNURDlwYStHVnY4VFNKZ1ZZMDVPbTlWLzZwYm9w?=
 =?utf-8?B?a1dQUHQ1MEtueDdzc2Q3eTdtT2hmcVhOV0IzdnQyZmZOSGpTUTE5ZDhrbTBi?=
 =?utf-8?B?V05rcFg5cEEzaHdJb1RqYzR5Zkoyc0JNb3RjRVZ4bm1iY1Y1dUhXS2Y0Zll3?=
 =?utf-8?B?bXJ3UDUvVlhUdGJ0MnliTitkVzFRbEZzT3JMbEJiWU4wZm1QWkJGSlQ5SERm?=
 =?utf-8?B?QmUzYXhWMEtLOWExZ1E2ZE42dEVaZVdmZnc3TDZhN2RrWXZJMURvellScXN1?=
 =?utf-8?Q?W0p4kAaP6z0J3Uy/g7KW2auxi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db501967-196f-4dd1-ae14-08da8efac314
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 04:54:49.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afCuP90OhkbT8MkRpeFLyffPiIj8Qv/b0OFlEZuG1PwBsJ9XxGak0JIfImqOTXwSCX4/NUesa8uqMx581ohOIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6554
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/2022 12:12 AM, Alex Williamson wrote:
> On Mon, 29 Aug 2022 17:18:45 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> This is part 2 for the vfio-pci driver power management support.
>> Part 1 of this patch series was related to adding D3cold support
>> when there is no user of the VFIO device and has already merged in the
>> mainline kernel. If we enable the runtime power management for
>> vfio-pci device in the guest OS, then the device is being runtime
>> suspended (for linux guest OS) and the PCI device will be put into
>> D3hot state (in function vfio_pm_config_write()). If the D3cold
>> state can be used instead of D3hot, then it will help in saving
>> maximum power. The D3cold state can't be possible with native
>> PCI PM. It requires interaction with platform firmware which is
>> system-specific. To go into low power states (Including D3cold),
>> the runtime PM framework can be used which internally interacts
>> with PCI and platform firmware and puts the device into the
>> lowest possible D-States.
>>
>> This patch series adds the support to engage runtime power management
>> initiated by the user. Since D3cold state can't be achieved by writing
>> PCI standard PM config registers, so new device features have been
>> added in DEVICE_FEATURE IOCTL for low power entry and exit related
>> handling. For the PCI device, this low power state will be D3cold
>> (if the platform supports the D3cold state). The hypervisors can implement
>> virtual ACPI methods to make the integration with guest OS.
>> For example, in guest Linux OS if PCI device ACPI node has
>> _PR3 and _PR0 power resources with _ON/_OFF method, then guest
>> Linux OS makes the _OFF call during D3cold transition and
>> then _ON during D0 transition. The hypervisor can tap these virtual
>> ACPI calls and then do the low power related IOCTL.
>>
>> The entry device feature has two variants. These two variants are mainly
>> to support the different behaviour for the low power entry.
>> If there is any access for the VFIO device on the host side, then the
>> device will be moved out of the low power state without the user's
>> guest driver involvement. Some devices (for example NVIDIA VGA or
>> 3D controller) require the user's guest driver involvement for
>> each low-power entry. In the first variant, the host can move the
>> device into low power without any guest driver involvement while
>> in the second variant, the host will send a notification to user
>> through eventfd and then user guest driver needs to move the device
>> into low power. The hypervisor can implement the virtual PME
>> support to notify the guest OS. Please refer
>> https://lore.kernel.org/lkml/20220701110814.7310-7-abhsahu@nvidia.com/
>> where initially this virtual PME was implemented in the vfio-pci driver
>> itself, but later-on, it has been decided that hypervisor can implement
>> this.
>>
>> * Changes in v7
> 
> Applied to vfio next branch for v6.1.  Thanks,
> 
> Alex
> 

 Thanks Alex for your guidance and support.
 
 Regards,
 Abhishek
